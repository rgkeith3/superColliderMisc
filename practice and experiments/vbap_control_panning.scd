s.reboot()
s.options.numWireBufs_(1024)



// generate n points on sphere
~t = TDesign.newHoa(24);
~t.visualize
// encode n signals at n points into hoa
~enc = HoaMatrixEncoder.newSphericalDesign(~t);
// convert hoa to foa
~hoafoa = FoaEncoderMatrix.newHoa1;
// decode foa to binaural
~dec = FoaDecoderKernel.newListen

// vbap is panaz for spherical points
// here, the speakers represent the n signals
~v = VBAPSpeakerArray.new(3, ~t.directions.raddeg)
~b = ~v.loadToBuffer


(x.free; x = {
	// in this case, vbap is being used to pan a control signal across the points, which will control sinoscfbs at all the points
	// var sig = SinOscFB.ar(150, VBAP.ar(~v.speakers.size, 10, ~b, LFNoise2.ar(1, pi), LFNoise2.ar(1, pi/2), 10), 1/24);
	// in this case, vbap is just panning around a Saw
	// but either way the outcome will be 24 signals, in order of the directions supplied to the vbap speaker array
	var sig = VBAP.ar(~v.speakers.size, Saw.ar(150), ~b, LFNoise2.ar(1, pi), LFNoise2.ar(1, pi/2), 10);
	sig = HoaEncodeMatrix.ar(sig, ~enc);
	sig = FoaEncode.ar(sig, ~hoafoa);
	FoaDecode.ar(sig, ~dec);
}.play)
