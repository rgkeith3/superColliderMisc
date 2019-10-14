s.quit;s.boot;
(
{
	var trig = Dust.kr(MouseX.kr(0, 50));
	var pan = Latch.kr(LFNoise1.kr(50), trig);
	var sig = Pluck.ar(PinkNoise.ar(), trig, delaytime: MouseY.kr(0, 0.05), decaytime: 10);
	sig = Pan2.ar(sig, pan);
	FreeVerb2.ar(sig[0], sig[1], mix: 0.5);
}.play
)

(
{
    var a, freq, trig;
    a = Dswitch1([1, 3, MouseY.kr(1, 15), 2, Dwhite(0, 3, 2)], MouseX.kr(0, 4));
    trig = Impulse.kr(3);
    freq = Demand.kr(trig, 0, a) * 30 + 340;
    SinOsc.ar(freq) * 0.1

}.play;
)

(
SynthDef
)


(
{
	var freq = Demand.kr(MouseButton.kr(), MouseButton.kr(), demandUGens: [Diwhite.new(50, 500)]);
	SinOsc.ar(freq);
}.play
)

(
a = { |t_trig, t_reset|
    var    d = Demand.kr(t_trig + t_reset, t_reset, Dseries(0, 1, inf));
    d.poll(t_trig + t_reset);
    0.0;
}.play
)
a.set(\t_trig, 1); // do this a few times -- the demand value should increase by 1 each time
a.set(\t_reset, 1);    // goes immediately back to 0

(
    {
        var d, trig;
        d = Dswitch([
		1,
		2,
		3
	], Dseq([0,1], 5));

        trig = Impulse.kr(4);

        Demand.kr(trig, 0, d).poll(trig);
    }.play;
);

{
var a, b, t = Impulse.kr(2);
a = { Dseq([1, 2, 3, 4, 5], inf) } * 100;
b = a + 1;
Demand.kr(t, 0, [a, b]).poll(t)
}.play

(
{
    var freq, trig, reset, seq1, seq2;
	trig = MouseButton.kr();
    seq1 = Dseq([72, 75, 79, 82], inf).midicps;
	freq = Demand.kr(trig, 0, seq1).poll(trig);
    SinOsc.ar(freq + [0,0.7]).cubed.cubed * 0.1;
}.play;
)

(
{
	var
}.play;
)

x = { {|freq| SinOsc.ar(freq);}.play } ! 4;
y = x[0]
y.set(\freq, 300);
z = x[2]
z.set(\freq, 100);
x[1].set(\freq, 150);
x[3].set(\freq, 400);

(
a = { { |t_trig, time, pan| Pan2.ar(Pluck.ar(PinkNoise.ar(), t_trig, delaytime: time, decaytime: 10), pan) }.play } ! 4;

)




( {
	t = Impulse.kr(4);
	a = { {|t_trig, time, pan| Pan2.ar(Pluck.ar(PinkNoise.ar(), t_trig, delaytime: time, decaytime: 10), pan) } } ! 4;
	d = Demand.kr(t, 0, Dseq([0,1,2,3], inf)).poll(t);
	a[d].play;
}.play
)

({
	t = Impulse.kr(4);
	d = Demand.kr(t, 0, Dseq([0,1,2,3], inf)).poll(4);
}.play)
(
var left, right;
// Pan2 uses an OutputProxy for each of its two outputs.
# left, right = Pan2.ar(WhiteNoise.ar, 0.0);
left.source.postln;
)









