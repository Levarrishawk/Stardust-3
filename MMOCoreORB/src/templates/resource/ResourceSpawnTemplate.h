/*
 * SharedResourceContainerObjectTemplate.h
 *
 *  Created on: 06/05/2010
 *      Author: kyle
 */

#ifndef RESOURCESPAWNTEMPLATE_H_
#define RESOURCESPAWNTEMPLATE_H_

#include "templates/tangible/SharedResourceContainerObjectTemplate.h"

class ResourceSpawnTemplate : public SharedResourceContainerObjectTemplate {
private:

public:
	ResourceSpawnTemplate() {

	}

	~ResourceSpawnTemplate() {

	}

	void readObject(LuaObject* templateData) {
		SharedResourceContainerObjectTemplate::readObject(templateData);

	}
};

#endif /* RESOURCESPAWNTEMPLATE_H_ */
