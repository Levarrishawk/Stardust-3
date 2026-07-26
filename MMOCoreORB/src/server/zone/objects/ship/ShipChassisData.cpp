//
// Created by g on 12/21/17.
//

#include "ShipChassisData.h"
#include "templates/datatables/DataTableRow.h"

ShipChassisData::ShipChassisData(DataTableRow* row, Vector<String>& columnNames) : Object() {
	row->getCell(0)->getValue(name);
	row->getCell(3)->getValue(wingOpenSpeed);

	const int start = 4;
	const int numComponents = (columnNames.size()-start)/3;
	String compatability;
	int hitweight;
	bool targetable;
	for (int i=start; i<columnNames.size(); i+=3) {
		String componentName = columnNames.get(i);
		row->getCell(i)->getValue(compatability);
		if (compatability.isEmpty()) {
			continue;
		}
		row->getCell(i+1)->getValue(hitweight);
		row->getCell(i+2)->getValue(targetable);
		componentMap.put(componentName, new ComponentSlotData(componentName, compatability, hitweight, targetable));
	}

}

ShipChassisData::~ShipChassisData() {
	componentMap.removeAll();
}
