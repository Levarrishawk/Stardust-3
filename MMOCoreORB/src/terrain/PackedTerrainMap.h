#ifndef PACKEDTERRAINMAP_H_
#define PACKEDTERRAINMAP_H_

#include "TemplateVariable.h"
#include <climits>

class PackedTerrainMap {
	int width = 0;
	int height = 0;
	int bitsPerElement = 0;
	int minimum = 0;
	Vector<uint8> data;

public:
	void clear() {
		width = height = bitsPerElement = minimum = 0;
		data.removeAll();
	}

	void readObject(IffStream* stream) {
		clear();
		if (stream->openForm('PIMP') == nullptr || stream->openForm('0000') == nullptr)
			throw Exception("Unsupported packed terrain map in " + stream->getFileName());
		Chunk* control = stream->openChunk('CNTL');
		if (control == nullptr || control->getChunkSize() != 16)
			throw Exception("Invalid packed terrain map control data in " + stream->getFileName());
		width = stream->getInt();
		height = stream->getInt();
		bitsPerElement = stream->getInt();
		minimum = stream->getInt();
		stream->closeChunk('CNTL');
		if (width <= 0 || height <= 0 || bitsPerElement < 0 || bitsPerElement > 32 || (uint64) width * height > INT_MAX)
			throw Exception("Invalid packed terrain map dimensions in " + stream->getFileName());
		uint64 bytes = ((uint64) width * height * bitsPerElement + 7) / 8;
		if (bytes == 0)
			bytes = 1;
		if (bytes > INT_MAX)
			throw Exception("Packed terrain map exceeds supported byte count in " + stream->getFileName());
		Chunk* chunk = stream->openChunk('DATA');
		if (chunk == nullptr || bytes != (uint64) chunk->getChunkSize())
			throw Exception("Invalid packed terrain map byte count in " + stream->getFileName());
		data.setSize((int) bytes);
		stream->getBytes((int) bytes, &data.getUnsafe(0));
		stream->closeChunk('DATA');
		stream->closeForm('0000');
		stream->closeForm('PIMP');
	}

	int getWidth() const { return width; }
	int getHeight() const { return height; }

	int getValue(int x, int y) const {
		if (x < 0 || y < 0 || x >= width || y >= height)
			throw Exception("Packed terrain map coordinate out of range");
		uint64 offset = ((uint64) y * width + x) * bitsPerElement;
		uint32 value = 0;
		for (int i = 0; i < bitsPerElement; ++i) {
			uint64 bit = offset + i;
			if (data.get((int) (bit / 8)) & (1U << (bit % 8)))
				value |= 1U << i;
		}
		int64 result = (int64) minimum + value;
		if (result < INT_MIN || result > INT_MAX)
			throw Exception("Packed terrain map value out of range");
		return (int) result;
	}
};

#endif /* PACKEDTERRAINMAP_H_ */
