Event.eventTypes
Pbind(\type, \note, \dur, 1, \tempo, 1, \degree, [1, 3, 5], \octave, 2,\strum, 0.1, \strumEndsTogether, true, \callback, {"hello".postln;}).play


(
Pbindef(\testingCallbacks,
	\type, \note,
	\dur, 1,
	\degree, Pseq([1,2,3], inf),
	\altAddress, b,
	\callback, {~altAddress.sendMsg("/hello", "there")}
).play
)

OSCFunc.trace(true)

// you can see it's sending osc in the callback. this would be where i would send osc to other apps.