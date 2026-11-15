#ifndef INSPIRATION_H_
#define INSPIRATION_H_

#include "system/lang/String.h"

namespace server {
namespace zone {
namespace objects {
namespace creature {

class CreatureObject;

}
}
}
}

namespace Inspiration {

constexpr auto BUFF_CRC = "stardust_inspiration"_hashCode;
constexpr const char* SECONDARY_DEFENSE = "private_inspiration_secondary_defense";
constexpr const char* SECOND_CHANCE = "private_inspiration_second_chance";
constexpr const char* EXPERIENCE = "private_inspiration_experience";
constexpr const char* ASSEMBLY = "private_inspiration_assembly";
constexpr const char* AMAZING_SUCCESS = "private_inspiration_amazing_success";

bool isAudienceMember(server::zone::objects::creature::CreatureObject* performer,
		server::zone::objects::creature::CreatureObject* patron);
void open(server::zone::objects::creature::CreatureObject* performer,
		server::zone::objects::creature::CreatureObject* patron);

}

#endif // INSPIRATION_H_
