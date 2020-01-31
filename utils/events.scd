(
Event.addEventType(\oscNote, {
	~netAddr = ~netAddr ?? NetAddr("localhost", 10000);
	currentEnvironment.keys.do {|key|
		if ("/".matchRegexp(key.asString)) {
			~netAddr.sendMsg(key.asString, currentEnvironment[key])
		}
	};

	~type = \note;
	currentEnvironment.play;
});

Event.addEventType(\osc, {
	~netAddr = ~netAddr ?? NetAddr("localhost", 10000);
	currentEnvironment.keys.do {|key|
		if ("/".matchRegexp(key.asString)) {
			~netAddr.sendMsg(key.asString, currentEnvironment[key])
		}
	};
})

)
