/**
 * @file Frame.ts
 */

/// <reference path="types/FrameCore.d.ts"/>

class Frame
{
	mCore: FrameCoreIF

	constructor(core: FrameCoreIF){
		this.mCore = core ;
	}
}

