s.boot
// would like to:
// 1. position a set number of synths around the soundfield
// 2. like we use PanAz to pan a modulation signal across those synths, use a HOA panner to pan the modulation signal across the synths
// the number of synths MUST be a order of ambisonics? not sure if this would actually work....
// the modulator can't be an ambisonic signal, but the shape of the mod must match the shape of the synths

// maybe you can project the mod as a foa ambisonic signal and then decode it as directions, then add them to the signals
~dirs = SphericalDesign.newT(16).points.collect({|p| [p.theta, p.phi]});
~modDecoder = FoaDecoderMatrix.newFromMatrix(FoaEncoderMatrix.newDirections(~dirs).matrix.pseudoInverse, ~dirs);
(x.free; x = {
	var mod, sig, points = SphericalDesign.newT(16).points;
	// mod is a foa signal
	mod = FoaEncode.ar(DC.ar(1), FoaEncoderMatrix.newOmni());
	mod = FoaPush.ar(mod, pi/2,  MouseY.kr(-pi, pi), MouseX.kr(-pi/2, pi/2));
	// mod is decoded channels
	mod = FoaDecode.ar(mod, ~modDecoder);
}.scope)