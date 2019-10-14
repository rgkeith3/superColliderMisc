(

{

var carrier, modulator, carrfreq, modfreq;


carrfreq= MouseX.kr(440,5000,'exponential');

modfreq= MouseY.kr(1,5000,'exponential');


carrier= SinOsc.ar(carrfreq,0,0.5);

modulator= SinOsc.ar(modfreq,0,0.5);


carrier*modulator;

}.scope

)

s.boot

(

{

var carrier, modulator, carrfreq, modfreq;


carrfreq= MouseX.kr(440,5000,'exponential');

modfreq= MouseY.kr(1,5000,'exponential');


carrier= SinOsc.ar(carrfreq,0,0.5);

modulator= SinOsc.ar(modfreq,0,0.25, 0.25);


carrier*modulator;

}.scope

)

(

{

var modfreq, modindex;


modfreq= MouseX.kr(1,440, 'exponential');

modindex=MouseY.kr(0.0,10.0);


SinOsc.ar(SinOsc.ar(modfreq,0,modfreq*modindex, 440),0,0.25)

}.scope

)


(

{

var carrfreq, modfreq, harmonicity, modindex;


//fc is frequency of carrier

//fm is frequency of modulator


carrfreq= 440; //MouseY.kr(330,550);

harmonicity= MouseX.kr(0,10).round(1);

modindex= MouseY.kr(0.0,10.0); //which is really modulation amplitude/modulation frequency, acts as brightness control as energy distribution changed over components


modfreq= carrfreq*harmonicity; //since harmonicity is an integer,


SinOsc.ar(carrfreq+(SinOsc.ar(modfreq)*modfreq*modindex), 0.0,0.1);


}.play

)


(

{

var modfreq, modindex, conversion;


modfreq= MouseX.kr(1,1000, 'exponential');

modindex=MouseY.kr(0.0,100.0);

conversion= 2pi/(s.sampleRate);


//Phasor is a UGen which will loop around a given interval, in this case 0 to 2pi, taking us around the waveform of the sinusoid; note that all the action is in the phase input

SinOsc.ar(0, Phasor.ar(0,440*conversion,0,2pi)+( (modfreq*modindex)*conversion*SinOsc.ar(modfreq)), 0.25)


//simpler alternative

//SinOsc.ar(440, ( (modf*ind)*conversion*SinOsc.ar(modf)), 0.25)

}.scope

)


({
	SinOscFB.ar(MouseY.kr(50, 5000, 'exponential'), MouseX.kr())
}.play)




{Mix(Saw.ar([440,443,437],0.1))}.scope

(

{

	Mix(

		Resonz.ar(			//The Resonz filter has arguments input, freq, rq=bandwidth/centre frequency

		Saw.ar([440,443,437] + SinOsc.ar(100,0,100)), //frequency modulated sawtooth wave with chorusing

		XLine.kr(10000,10,10), //vary filter bandwidth over time

		Line.kr(1,0.05, 10), //vary filter rq over time

		mul: LFSaw.kr(Line.kr(3,17,3),0,0.5,0.5)*Line.kr(1,0,10)  //AM

	)

	)

}.scope

)


(

b=Buffer.read(s,Platform.resourceDir +/+ "sounds/a11wlk01.wav");

//b.Buffer.read(s,"sounds/a11wlk01.wav"); //SC3.4 or earlier

)



//now me!

(


{

var modfreq, modindex, modulator;


modfreq= MouseX.kr(1,4400, 'exponential');

modindex=MouseY.kr(0.0,10.0,'linear');


modulator= SinOsc.kr(modfreq,0,modfreq*modindex, 440);


PlayBuf.ar(1,b, BufRateScale.kr(b)* (modulator/440), 1, 0, 1)


}.scope;

)
