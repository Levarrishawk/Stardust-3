#ifndef BUFFBUILDERCHANGEMESSAGECALLBACK_H_
#define BUFFBUILDERCHANGEMESSAGECALLBACK_H_

#include "ObjectControllerMessageCallback.h"
#include "server/zone/objects/player/sessions/Inspiration.h"
#include "server/zone/objects/player/sessions/InspirationState.h"

class BuffBuilderChangeMessageCallback : public MessageCallback {
	InspirationUpdate update;
	bool cancel;
	bool parsed = false;

public:
	BuffBuilderChangeMessageCallback(ObjectControllerMessageCallback* controller)
			: MessageCallback(controller->getClient(), controller->getServer()), cancel(controller->getType() == Inspiration::CANCEL_MESSAGE) {
	}

	void parse(Message* message) override;
	void run() override;
};

#endif // BUFFBUILDERCHANGEMESSAGECALLBACK_H_
