﻿////////////////////////////////////////////////////////////////////////////////
//
//  IDEUM
//  Copyright 2009-2011 Ideum
//  All Rights Reserved.
//
//  OPEN EXHIBITS SDK (OPEN EXHIBITS CORE)
//
//  File:    	Activator.as
//
//  Authors:   	Chris Gerber (chris(at)ideum(dot)com),
//				Matthew Valverde (matthew(at)ideum(dot)com), 
//				Paul Lacey (paul(at)ideum(dot)com).
//
//  NOTICE: OPEN EXHIBITS SDK permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package gl.activators
{

import id.core.Descriptor;

public class Activator extends Descriptor
{
	
	override public function get priority():uint
	{
		return (super.priority | (1<<8)) << 16 ;
	}
	
}
	
}