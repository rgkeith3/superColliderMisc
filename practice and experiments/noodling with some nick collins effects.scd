{FreqShift.ar(Mix(SinOsc.ar(100*(1..6)))*0.1,MouseX.kr(0,1000),SinOsc.ar(MouseY.kr(0,100)))}.scope;
s.boot

(

{

	var distance = MouseX.kr(1,100); //1 to 100 metres



	LPF.ar(WhiteNoise.ar(0.5),10000-(distance*80))/distance;



}.scope

)

//reference sound

{Saw.ar(440,0.2)}.play


//starts above pitch, ends below pitch, due to cycle starts being closer together when approaching (reducing delay), and further apart when retreating (increasing delay)

(

{

var radialdistance = Line.kr(10,-10,5,doneAction:2);


DelayC.ar(Saw.ar(440,0.2),1.0, radialdistance.abs/340.0);



}.scope

)

(

{

var source, radialdistance, absoluterd, dopplershift, amplitude;


source= Saw.ar(Demand.kr(Impulse.kr(LFNoise0.kr(0.5,0.1,2)),0,Dseq([63,60].midicps,inf)));	//nee-naw emergency vehicle simulation



//in metres, moving at 6.8 metres per second

radialdistance= EnvGen.ar(Env([34,-34],[10]),doneAction:2);


absoluterd= radialdistance.abs;


//if something is 340 metres away, takes 1 second to get there; so make delay depend on distance away in metres

dopplershift= DelayC.ar(source, 1.0, absoluterd/340.0);


//inversely proportional

amplitude= (absoluterd.max(1.0)).reciprocal;


Pan2.ar(amplitude*dopplershift,0.0)

}.play

)

(

{

var source, distance, radialdistance, absoluterd, dopplershift, amplitude;

var side, angle;


source= Saw.ar(Demand.kr(Impulse.kr(LFNoise0.kr(0.5,0.1,2)),0,Dseq([63,60].midicps,inf))); //nee-naw emergency vehicle simulation



side=5;

//central side marker, placed 5 metres directly right of observer, observer facing ahead

//in metres, moving at 6.8 metres per second

distance=  EnvGen.ar(Env([34,-34],[10]), doneAction:2);


angle= atan(distance/side);


//radial distance by

absoluterd= (distance.squared+ side.squared).sqrt;


dopplershift= DelayC.ar(source, 1.0, absoluterd/340.0);


//inversely proportional

amplitude= (absoluterd.max(1.0)).reciprocal;


Pan2.ar(amplitude*dopplershift,1.0)

}.play

)

b = Buffer.read(s,Platform.resourceDir +/+"sounds/a11wlk01.wav");


//overlaps eight windows of 0.1 seconds, so one window every 0.1/8 = 0.0125 seconds

{Warp1.ar(1,b,pointer:MouseX.kr,windowSize:MouseY.kr(0.1, 1), overlaps: 24)}.scope
{GrainBuf.ar(2, Impulse.kr(250), MouseY.kr(0.0001, 0.1), b, pos: MouseX.kr, pan: WhiteNoise.kr * MouseY.kr(0.0001, 1) + MouseX.kr(-1, 1))}.play


//increasingly randomise window shape to avoid rough repetition sounds

{Warp1.ar(1,b,pointer:MouseX.kr,freqScale:1.0,windowSize:0.1, windowRandRatio:MouseY.kr(0.0,1))}.scope

{WarpOverlap.ar(1, b, 8, 0, 4, 1)}.play


(
x = {
	arg pitch = 400;
	var freq, has_freq, sig, pitchRatio;
	sig = Warp1.ar(1, b, pointer: MouseX.kr, windowRandRatio: 0, windowSize: 0.01);
	#freq, has_freq = Tartini.kr(sig);
	freq.poll;

	pitchRatio = pitch / freq;

	pitchRatio.poll;
	PitchShift.ar(sig, pitchRatio: pitch / freq, timeDispersion: 0.01)!2;
}.play
)

x.set(\pitch, 50)






