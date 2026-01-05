/** 
 * @file FrameCore.d.ts
 */

interface FrameCoreIF {
	_value(p0: string): any ;
	_setValue(p0: string, p1: any): boolean ;
	_definePropertyType(p0: string, p1: string): void ;
	_addObserver(p0: string, p1: () => void): void ;
}

/**
 * @file Frame.ts
 */
declare class Frame {
    mCore: FrameCoreIF;
    constructor(core: FrameCoreIF);
}
