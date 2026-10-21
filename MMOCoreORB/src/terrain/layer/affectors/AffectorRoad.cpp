/*
 * AffectorRoad.cpp
 *
 * Created on: 2/2/2024
 * Author: Hakry
 */

#include "AffectorRoad.h"
#include "../../TerrainGenerator.h"

#include "../ProceduralRule.h"
#include "AffectorProceduralRule.h"
#include "../Road.h"
#include "../HeightData.h"

void AffectorRoad::process(float x, float y, float transformValue, float& baseValue, TerrainGenerator* terrainGenerator) {
	if (hasFixedHeights) {
		processFixedHeights(x, y, transformValue, baseValue);
		return;
	}

#ifdef DEBUG_AFFECTOR_ROAD
	StringBuffer msg;
	msg << "process function called for location X: " << x << " Y: " << y << " transformValue: " << transformValue << " baseValue: " << baseValue << endl;
#endif

	// not a height type
	if (type != 'HDTA' || transformValue == 0)
		return;

	float deltaX = x - startPoint.getX();
	float deltaY = y - startPoint.getY();

	float thisDistSq = (deltaX * deltaX + deltaY * deltaY);

	if (thisDistSq > OUT_OF_RANGE * OUT_OF_RANGE)
		return;

	/*	Process the RoadData
		1. Check if the coordinate falls in one of the roads using the rectangles vector
		2. Find nearest segment to passed point from PTA and set it to Z coordinate
	*/

	bool onRoadway = false;
	Vector3 roadStart;
	Vector3 roadCenter;
	float direction = 0.f;

	for (int i = 0; i < rectangles.size(); ++i) {
		RoadRectangle* rect = rectangles.get(i);

#ifdef DEBUG_AFFECTOR_ROAD
		msg << "Checking Rectangle #" << i << " LL X: " << rect->getLowerLeftX() << " LL Y: " << rect->getLowerLeftY() << " UR X: " << rect->getUpperRightX() << " UR Y: " << rect->getUpperRightY() << endl;
#endif

		if (rect == nullptr || !rect->containsPoint(x, y))
			continue;

		// Found the road point is in
		onRoadway = true;
		roadStart.setX(rect->getRoadStartX());
		roadStart.setY(rect->getRoadStartY());

		roadCenter.setX(rect->getRoadCenterX());
		roadCenter.setY(rect->getRoadCenterY());
		direction = rect->getDirection();

		break;
	}

	// Point is not within one of the roads rectangles
	if (!onRoadway) {
#ifdef DEBUG_AFFECTOR_ROAD
		msg << "Point is not located on a roadway." << endl;
		sendDebugMessage(msg.toString());
#endif
		return;
	}

#ifdef DEBUG_AFFECTOR_ROAD
	msg << "Point is within bounds of roadway -- Road Start - X: " << roadStart.getX() << " Y: " << roadStart.getY() << endl;
#endif

	hdta.findNearestHeight(baseValue, Vector3(x, y, baseValue), roadStart, roadCenter, direction);

#ifdef DEBUG_AFFECTOR_ROAD
	msg << "Height Coordinate Result: " << baseValue << endl;
	sendDebugMessage(msg.toString());
#endif
}

void AffectorRoad::parseFromIffStream(engine::util::IffStream* iffStream) {
	uint32 version = iffStream->getNextFormType();

	iffStream->openForm(version);

	switch (version) {
		case '0005':
			parseFromIffStream(iffStream, Version<'0005'>());
			break;
		case '0006':
			parseFromIffStream(iffStream, true);
			break;
		default:
			Logger::console.error() << "unknown AffectorRoad version 0x" << hex << version << endl;
			break;
	}

	iffStream->closeForm(version);
}

void AffectorRoad::parseFromIffStream(engine::util::IffStream* iffStream, Version<'0005'>) {
	parseFromIffStream(iffStream, false);
}

void AffectorRoad::parseFromIffStream(engine::util::IffStream* iffStream, bool hasHeightList) {
	hasFixedHeights = false;
	fixedHeights.removeAll();
	informationHeader.readObject(iffStream);

	iffStream->openForm('DATA');

	type = iffStream->getNextFormType();

	switch (type) {
		case ('ROAD'):
			road.readObject(iffStream);
			break;
		case ('HDTA'):
			hdta.readObject(iffStream);
			break;
		default:
			Logger::console.error() << "Unknown type in AffectorRoad, expecting ROAD or HDTA!\n";
			break;
	}

	iffStream->openChunk('DATA');

	coordinateCount = iffStream->getInt();
	if (hasHeightList && (coordinateCount < 2 || coordinateCount > iffStream->getDataSize() / 8))
		throw Exception("Invalid AROA control point count in " + iffStream->getFileName());

#ifdef DEBUG_AFFECTOR_ROAD
	StringBuffer msg;
#endif

	for (int i = 0; i < coordinateCount; i++) {
		if (i == 0) {
			startPoint.x = iffStream->getFloat();
			startPoint.y = iffStream->getFloat();

#ifdef DEBUG_AFFECTOR_ROAD
			msg << "Loading Road Start Position - X: " << startPoint.x << " Y: " << startPoint.y << endl;
#endif
		} else if (i == coordinateCount - 1) {
			endPoint.x = iffStream->getFloat();
			endPoint.y = iffStream->getFloat();

#ifdef DEBUG_AFFECTOR_ROAD
			msg << "Loading Road End Position - X: " << endPoint.x  << " Y: " << endPoint.y << endl;
#endif
		} else {
			Point2D* pos = new Point2D();
			pos->x = iffStream->getFloat();
			pos->y = iffStream->getFloat();

#ifdef DEBUG_AFFECTOR_ROAD
			msg << "Loading Road Mid-Position - X: " << pos->x << " Y: " << pos->y << endl;
#endif
			midPositions.add(pos);
		}
	}

	if (hasHeightList) {
		int count = iffStream->getInt();
		if (count < 0 || count > iffStream->getDataSize() / 4)
			throw Exception("Invalid AROA height count in " + iffStream->getFileName());
		for (int i = 0; i < count; ++i)
			fixedHeights.add(iffStream->getFloat());
	}

	width = iffStream->getFloat() * (hasHeightList ? 1.f : 0.7f);
	familyID = iffStream->getInt();
	featheringType = iffStream->getInt();
	featheringAmount = Math::clamp(0.f, iffStream->getFloat(), 1.f);
	featheringShader = iffStream->getInt();
	featheringShaderDistance = Math::clamp(0.f, iffStream->getFloat(), 1.f);
	if (hasHeightList) {
		hasFixedHeights = iffStream->getInt() != 0;
		if (coordinateCount < 2 || (hasFixedHeights && fixedHeights.size() != coordinateCount))
			throw Exception("Invalid AROA control/height list in " + iffStream->getFileName());
	}

#ifdef DEBUG_AFFECTOR_ROAD
	sendDebugMessage(msg.toString());
#endif

	iffStream->closeChunk('DATA');

	iffStream->closeForm('DATA');

	// Generate rectangles for roadways
	generateRectangles();
}

const Point2D& AffectorRoad::getControlPoint(int index) const {
	if (index == 0)
		return startPoint;
	if (index == coordinateCount - 1)
		return endPoint;
	return *midPositions.get(index - 1);
}

void AffectorRoad::processFixedHeights(float x, float y, float transformValue, float& baseValue) const {
	if (transformValue == 0 || width <= 0)
		return;

	float halfWidth = width / 2.f;
	float distanceSquared = halfWidth * halfWidth;
	int nearest = -1;
	float fraction = 0;

	for (int i = 0; i < coordinateCount; ++i) {
		const Point2D& point = getControlPoint(i);
		float dx = x - point.x;
		float dy = y - point.y;
		float distance = dx * dx + dy * dy;
		if (distance < distanceSquared) {
			distanceSquared = distance;
			nearest = i;
			fraction = 0;
		}
	}

	for (int i = 0; i < coordinateCount - 1; ++i) {
		const Point2D& start = getControlPoint(i);
		const Point2D& end = getControlPoint(i + 1);
		float dx = end.x - start.x;
		float dy = end.y - start.y;
		float lengthSquared = dx * dx + dy * dy;
		if (lengthSquared == 0)
			continue;
		float u = ((x - start.x) * dx + (y - start.y) * dy) / lengthSquared;
		if (u < 0 || u > 1)
			continue;
		float offsetX = x - (start.x + u * dx);
		float offsetY = y - (start.y + u * dy);
		float distance = offsetX * offsetX + offsetY * offsetY;
		if (distance < distanceSquared) {
			distanceSquared = distance;
			nearest = i;
			fraction = u;
		}
	}

	if (nearest < 0)
		return;

	float height = fixedHeights.get(nearest);
	if (nearest < coordinateCount - 1)
		height += fraction * (fixedHeights.get(nearest + 1) - height);

	float feather = 1.f;
	float innerWidth = halfWidth * (1.f - featheringAmount);
	if (featheringAmount > 0 && distanceSquared >= innerWidth * innerWidth) {
		feather = 1.f - (sqrt(distanceSquared) - innerWidth) / (halfWidth - innerWidth);
		switch (featheringType) {
		case 1: feather *= feather; break;
		case 2: feather = sqrt(feather); break;
		case 3: feather = feather * feather * (3.f - 2.f * feather); break;
		}
	}
	baseValue += (height - baseValue) * feather * transformValue;
}

void AffectorRoad::generateRectangles() {
#ifdef DEBUG_AFFECTOR_ROAD
	StringBuffer msg;
	msg << "generateRectangles called - midPositions Size: " << midPositions.size();
	sendDebugMessage(msg.toString());
#endif

	// There are no mid points, generate rectangle only based off of start and end point
	if (midPositions.size() == 0) {
		addNewRectangle(startPoint.x, startPoint.y, endPoint.x, endPoint.y);
		return;
	}

	Point2D point1(startPoint.x, startPoint.y);

	for (int i = 0; i < midPositions.size(); i++) {
		Point2D* position = midPositions.get(i);

		if (position == nullptr)
			continue;

		addNewRectangle(point1.x, point1.y, position->getX(), position->getY());

		point1.x = position->getX();
		point1.y = position->getY();
	}

	// Add final rectangle
	addNewRectangle(point1.x, point1.y, endPoint.x, endPoint.y);
}

void AffectorRoad::addNewRectangle(float x1, float y1, float x2, float y2) {
	float widthHalf = width / 2.0f;

	float deltaX = x1 - x2;
	float deltaY = y1 - y2;
	float directionAngle = atan2(deltaY, deltaX);

	directionAngle = M_PI / 2 - directionAngle;

	if (directionAngle < 0) {
		float a = M_PI + directionAngle;
		directionAngle = M_PI + a;
	}

	float xLowerLeft = x2 + (-widthHalf * Math::cos(directionAngle) + (0.f * Math::sin(directionAngle)));
	float yLowerLeft = y2 + (widthHalf * Math::sin(directionAngle) + (0.f * Math::cos(directionAngle)));

	float xUppperRight = x1 + (widthHalf * Math::cos(directionAngle) + (0.f * Math::sin(directionAngle)));
	float yUppperRight = y1 + (-widthHalf * Math::sin(directionAngle) + (0.f * Math::cos(directionAngle)));

	RoadRectangle* rect = new RoadRectangle(xLowerLeft, yLowerLeft, xUppperRight, yUppperRight, x1, y1, width, directionAngle);

	rectangles.add(rect);

#ifdef DEBUG_AFFECTOR_ROAD
	StringBuffer msg;
	msg << "New Rectangle Road Added - UpperRight X: " << xUppperRight << " UpperRightY: " << yUppperRight << " LowerLeft X: " << xLowerLeft << " LowerLeft Y: " << yLowerLeft  << " directionAngle: " << directionAngle << endl;
	sendDebugMessage(msg.toString());
#endif
}

void AffectorRoad::sendDebugMessage(String message) {
	StringBuffer msg;

	msg << "AffectorRoad - Type: ";

	if (type == 'ROAD')
		msg << "ROAD";
	else if (type == 'HDTA')
		msg << "HDTA";
	else
		msg << "UNKNOWN";

	msg << " - coordinateCount: " << coordinateCount << " width: " << width << " familyID: " << familyID << " featheringType: " << featheringType << " featheringAmount: " << featheringAmount << " featheringShader: " << featheringShader << " featheringShaderDistance: " << featheringShaderDistance << endl;

	Logger::console.info(true) << msg << message;
}
