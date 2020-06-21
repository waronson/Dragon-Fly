Shader "OneBitPP2"
{
	Properties
	{
		_HatchColor("HatchColor", Color) = (0,0,0,0)
		_BackgroundColor("BackgroundColor", Color) = (1,1,1,1)
		_HatchSize("HatchSize", Float) = 6

	}

		HLSLINCLUDE

#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
		uniform float4 _HatchColor;
	uniform float4 _BackgroundColor;
	uniform float _HatchSize;
	TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
	float _Blend;

	float4 Frag(VaryingsDefault i) : SV_Target
	{
		float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
		float2 screenPos = i.texcoord;
		float temp_output_23_0 = floor(screenPos.x * _ScreenParams.x);
		float temp_output_24_0 = floor(screenPos.y * _ScreenParams.y);
		float clampResult49 = clamp(fmod((temp_output_23_0 + temp_output_24_0), _HatchSize), 0.0, 1.0);
		float clampResult45 = clamp(fmod(abs((temp_output_23_0 - temp_output_24_0)), _HatchSize), 0.0, 1.0);
		float clampResult37 = clamp(fmod((temp_output_23_0 + temp_output_24_0), (_HatchSize / 2.0)), 0.0, 1.0);
		float clampResult30 = clamp(fmod(abs((temp_output_23_0 - temp_output_24_0)), (_HatchSize / 2.0)), 0.0, 1.0);
		float4 lerpResult5 = lerp(_HatchColor, _BackgroundColor, (((((color - 0.0 > 0.45 ? 1.0 : color - 0.0 <= 0.45 && color + 0.0 >= 0.45 ? clampResult49 : clampResult49)  *  (color - 0.0 > 0.45 ? 1.0 : color - 0.0 <= 0.45 && color + 0.0 >= 0.45 ? clampResult45 : clampResult45)) *  (color - 0.0 > 0.3 ? 1.0 : color - 0.0 <= 0.3 && color + 0.0 >= 0.3 ? clampResult37 : clampResult37)) *  (color - 0.0 > 0.2 ? 1.0 : color - 0.0 <= 0.2 && color + 0.0 >= 0.2 ? clampResult30 : clampResult30)) *  (color - 0.0 > 0.06 ? 1.0 : color - 0.0 <= 0.06 && color + 0.0 >= 0.06 ? 0.0 : 0.0)));
		//float4 lerpResult2 = lerp((float4((color).rgb, 0.0) * lerpResult5), lerpResult5, 1.0);


		return lerpResult5 * .5;
	}

		ENDHLSL

		SubShader
	{
		Cull Off ZWrite Off ZTest Always

			Pass
		{
			HLSLPROGRAM

				#pragma vertex VertDefault
				#pragma fragment Frag

			ENDHLSL
		}
	}
}