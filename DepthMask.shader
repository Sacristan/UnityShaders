﻿Shader "Custom/Depth Mask" {

	SubShader{
		Tags{ "Queue" = "Geometry+10" }

		ColorMask 0
		ZWrite On

		Pass{}
	}
}