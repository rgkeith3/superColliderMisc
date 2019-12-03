s.boot
(
Event.addEventType(\noteAndOSC, {
	~message.postln;
	~type = \note;
	currentEnvironment.play;
})
)

(
Pbind(
	\type, \noteAndOSC,
	\dur, 1,
	\message, Pseq(["hello", "goodbye"], inf)
).play
)

// could make an event to take osc and send it
// could also make an event for playing slices that does all the calculations

(
Event.addEventType(\slice, {
	"slice".postln;
	~type = \noteAndOSC;
	currentEnvironment.play
})
)

(type: \slice, message: "hello").play