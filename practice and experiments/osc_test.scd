s.boot;

b = NetAddr.new("127.0.0.1", 7771);

(
p = Pbindef(\sendOscTest,
	\dur, Prand([1/3, 2/3, 1/4, 1/6], inf),
	\degree, Pseq([1,2,3], inf),
	\z, Pwhite(-2.0, 2.0),
	\pan, Pwhite(-1.0, 1.0),
	\callback, {b.sendMsg("/LightXYZI", ~pan * 5, ~degree * 2, ~z * 2, );}
).play
)