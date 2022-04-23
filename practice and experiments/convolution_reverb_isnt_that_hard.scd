s.boot

(
fork{
	var path, inSrc, irL, irR, convTime, fftsize, bufsizeL, bufsizeR, irSpctrmL, irSpctrmR, convolver;

	path= Platform.resourceDir; // path!

	"preparing buffers.. ".post;
	/*
	irL= Buffer.readChannel(s, path++"", channels:0); // IR left
	irR= Buffer.readChannel(s, path++"", channels:0); // IR right
	*/

	/* Test IRs */
	// test IRs begin. -->
	// synthesise the honourable 'Dan Stowell' impulse response */
	~ir= [1] ++ 0.dup(100) ++ (
		(1, 0.99998 .. 0)
		.collect {|f|
			f = f.squared.squared;
			f = if(f.coin) { 0 }{ f.squared };
			f = if(0.5.coin) { 0 - f } { f }
		} * 0.1
	);
	~irNorm = ~ir.normalizeSum;
	irR = Buffer.loadCollection(s, ~irNorm);
	irL = Buffer.loadCollection(s, ~irNorm);
	// <-- test IRs end.

	/* reverse IRs */
	"finished.. \nreverting IR buffers.. ".post;
	// irL.loadToFloatArray(action: { |array| irL.sendCollection(array.reverse) });
			// Only the right channel buffer is reversed for tests.
	irR.loadToFloatArray(action: { |array| irR.sendCollection(array.reverse) });

	s.sync;

	/* Increase the number 1 at the end of the following line if the sound is broken */

	// try this in a function to load irs into spectrum bufs not regular playable bufs
	fftsize= 2048;
	bufsizeL= PartConv.calcBufSize(fftsize, irL);
	irSpctrmL= Buffer.alloc(s, bufsizeL, 1);
	irSpctrmL.preparePartConv(irL, fftsize);
	bufsizeR= PartConv.calcBufSize(fftsize, irR);
	irSpctrmR= Buffer.alloc(s, bufsizeR, 1);
	irSpctrmR.preparePartConv(irR, fftsize);

	s.sync;

	irL.free; irR.free;

	"finished..\nconvolution is started.".postln;

	convolver= {
		var in, conv, mix;
		in = Saw.ar(MouseY.kr(50, 5000));
		conv = PartConv.ar (
			in,
			fftsize,
			[irSpctrmL.bufnum, irSpctrmR.bufnum],
			0.2 // Adjust the number to get a proper amplitude.
		);
		mix = (in * 0) + (conv * 1); // mix!
		Out.ar( 0, mix )
	}.play;
}
)

