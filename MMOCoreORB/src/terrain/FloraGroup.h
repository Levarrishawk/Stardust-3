/*
 * FloraGroup.h
 *
 *  Created on: 31/01/2010
 *      Author: victor
 */

#ifndef FLORAGROUP_H_
#define FLORAGROUP_H_


#include "TemplateVariable.h"
#include "FloraFamily.h"

class FloraGroup : public TemplateVariable<'FGRP'> {
	Vector<FloraFamily*> data;
public:
	const FloraFamily* getFamily(int familyID) const {
		for (int i = 0; i < data.size(); ++i) {
			if (data.get(i)->getFamilyID() == familyID)
				return data.get(i);
		}
		return nullptr;
	}

	~FloraGroup() {
		while (data.size() > 0)
			delete data.remove(0);
	}

	void parseFromIffStream(engine::util::IffStream* iffStream) {
		uint32 version = iffStream->getNextFormType();

		iffStream->openForm(version);

		switch (version) {
		case '0006':
		case '0007':
			parseFromIffStream(iffStream, version);
			break;
		case '0008':
			parseFromIffStream(iffStream, Version<'0008'>());
			break;
		default:
			System::out << "unknown FGRP version 0x" << hex << version;
			break;
		}

		iffStream->closeForm(version);
	}

	void parseFromIffStream(engine::util::IffStream* iffStream, Version<'0008'>) {
		parseFromIffStream(iffStream, (uint32) '0008');
	}

	void parseFromIffStream(engine::util::IffStream* iffStream, uint32 version) {
		int number = iffStream->getSubChunksNumber();

		for (int i = 0; i < number; ++i) {
			FloraFamily* ffam = new FloraFamily();
			ffam->readObject(iffStream, version);

			data.add(ffam);
		}
	}
};


#endif /* FLORAGROUP_H_ */
