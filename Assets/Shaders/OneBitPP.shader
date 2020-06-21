// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "OneBitPP"
{
	Properties
	{
		_HatchColor("HatchColor", Color) = (0,0,0,0)
		_BackgroundColor("BackgroundColor", Color) = (1,1,1,1)
		_HatchSize("HatchSize", Float) = 6
		_MainTex("MainTex", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}

	SubShader
	{
		LOD 0

		Cull Off
		ZWrite Off
		ZTest Always
		
		Pass
		{
			CGPROGRAM

			

			#pragma vertex Vert
			#pragma fragment Frag
			#pragma target 3.0

			#include "UnityCG.cginc"
			
		
			struct ASEAttributesDefault
			{
				float3 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				
			};

			struct ASEVaryingsDefault
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoordStereo : TEXCOORD1;
			#if STEREO_INSTANCING_ENABLED
				uint stereoTargetEyeIndex : SV_RenderTargetArrayIndex;
			#endif
				float4 ase_texcoord2 : TEXCOORD2;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			uniform float4 _HatchColor;
			uniform float4 _BackgroundColor;
			uniform float _HatchSize;


			
			float2 TransformTriangleVertexToUV (float2 vertex)
			{
				float2 uv = (vertex + 1.0) * 0.5;
				return uv;
			}

			ASEVaryingsDefault Vert( ASEAttributesDefault v  )
			{
				ASEVaryingsDefault o;
				o.vertex = float4(v.vertex.xy, 0.0, 1.0);
				o.texcoord = TransformTriangleVertexToUV (v.vertex.xy);
#if UNITY_UV_STARTS_AT_TOP
				o.texcoord = o.texcoord * float2(1.0, -1.0) + float2(0.0, 1.0);
#endif
				o.texcoordStereo = TransformStereoScreenSpaceTex (o.texcoord, 1.0);

				v.texcoord = o.texcoordStereo;
				float4 ase_ppsScreenPosVertexNorm = float4(o.texcoordStereo,0,1);

				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord2 = screenPos;
				

				return o;
			}

			float4 Frag (ASEVaryingsDefault i  ) : SV_Target
			{
				float4 ase_ppsScreenPosFragNorm = float4(i.texcoordStereo,0,1);

				float2 uv_MainTex = i.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode16 = tex2D( _MainTex, uv_MainTex );
				float4 screenPos = i.ase_texcoord2;
				float temp_output_23_0 = floor( screenPos.x );
				float temp_output_24_0 = floor( screenPos.y );
				float clampResult49 = clamp( fmod( ( temp_output_23_0 + temp_output_24_0 ) , _HatchSize ) , 0.0 , 1.0 );
				float clampResult45 = clamp( fmod( abs( ( temp_output_23_0 - temp_output_24_0 ) ) , _HatchSize ) , 0.0 , 1.0 );
				float clampResult37 = clamp( fmod( ( temp_output_23_0 + temp_output_24_0 ) , ( _HatchSize / 2.0 ) ) , 0.0 , 1.0 );
				float clampResult30 = clamp( fmod( abs( ( temp_output_23_0 - temp_output_24_0 ) ) , ( _HatchSize / 2.0 ) ) , 0.0 , 1.0 );
				float4 lerpResult5 = lerp( _HatchColor , _BackgroundColor , ( ( ( (  ( tex2DNode16 - 0.0 > 0.45 ? 1.0 : tex2DNode16 - 0.0 <= 0.45 && tex2DNode16 + 0.0 >= 0.45 ? clampResult49 : clampResult49 )  *  ( tex2DNode16 - 0.0 > 0.45 ? 1.0 : tex2DNode16 - 0.0 <= 0.45 && tex2DNode16 + 0.0 >= 0.45 ? clampResult45 : clampResult45 )  ) *  ( tex2DNode16 - 0.0 > 0.3 ? 1.0 : tex2DNode16 - 0.0 <= 0.3 && tex2DNode16 + 0.0 >= 0.3 ? clampResult37 : clampResult37 )  ) *  ( tex2DNode16 - 0.0 > 0.2 ? 1.0 : tex2DNode16 - 0.0 <= 0.2 && tex2DNode16 + 0.0 >= 0.2 ? clampResult30 : clampResult30 )  ) *  ( tex2DNode16 - 0.0 > 0.06 ? 1.0 : tex2DNode16 - 0.0 <= 0.06 && tex2DNode16 + 0.0 >= 0.06 ? 0.0 : 0.0 )  ));
				float4 lerpResult2 = lerp( ( float4( (tex2DNode16).rgb , 0.0 ) * lerpResult5 ) , lerpResult5 , 1.0);
				

				float4 color = lerpResult2;
				
				return color;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18100
-1891;56;1906;1013;4477.706;905.5035;1.115605;True;True
Node;AmplifyShaderEditor.ScreenPosInputsNode;20;-3637.148,215.6112;Float;False;1;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FloorOpNode;23;-3232.055,251.335;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FloorOpNode;24;-3237.256,326.735;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;48;-2766.419,124.5483;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;47;-2602.419,131.5483;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;52;-2601.257,-131.3613;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;25;-3271.054,688.1346;Inherit;False;Property;_HatchSize;HatchSize;2;0;Create;True;0;0;False;0;False;6;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;44;-2409.112,144.9405;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;34;-2637.581,774.1981;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;36;-2640.892,611.1562;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;41;-2638.321,481.0273;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;51;-2434.664,-114.3072;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;33;-2621.842,892.2448;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;49;-2175.429,-113.0528;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;16;-3425.147,-467.5735;Inherit;True;Property;_MainTex;MainTex;3;0;Fetch;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.AbsOpNode;32;-2481.31,774.1982;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;38;-2417.973,508.5945;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;45;-2149.877,146.1949;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;50;-2009.097,-163.9353;Inherit;False;6;0;COLOR;0,0,0,0;False;1;FLOAT;0.45;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;37;-2046.738,508.8489;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.FmodOpNode;31;-2305.923,796.6832;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;46;-1983.545,95.31245;Inherit;False;6;0;COLOR;0,0,0,0;False;1;FLOAT;0.45;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;30;-2027.688,789.9376;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;35;-1880.406,457.9665;Inherit;False;6;0;COLOR;0,0,0,0;False;1;FLOAT;0.3;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;43;-1714.012,-7.744715;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;29;-1861.357,739.0552;Inherit;False;6;0;COLOR;0,0,0,0;False;1;FLOAT;0.2;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;-1545.4,370.416;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCIf;27;-1855.549,1090.943;Inherit;False;6;0;COLOR;0,0,0,0;False;1;FLOAT;0.06;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1344.558,598.6052;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;7;-1375,94.5;Inherit;False;Property;_BackgroundColor;BackgroundColor;1;0;Create;True;0;0;False;0;False;1,1,1,1;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;6;-1375,-90.5;Inherit;False;Property;_HatchColor;HatchColor;0;0;Create;True;0;0;False;0;False;0,0,0,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-1130.727,795.5286;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;5;-1037,77.5;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ComponentMaskNode;19;-1956.08,-374.8079;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;4;-749,-221.5;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;3;-733,164.5;Inherit;False;Constant;_BackgroundOpacity;BackgroundOpacity;0;0;Create;True;0;0;False;0;False;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;2;-409,-0.5;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;1;False;1;COLOR;0
Node;AmplifyShaderEditor.DesaturateOpNode;18;-2927.293,-545.4552;Inherit;False;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;53;0,0;Float;False;True;-1;2;ASEMaterialInspector;0;2;OneBitPP;32139be9c1eb75640a847f011acf3bcf;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;False;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;;0
WireConnection;23;0;20;1
WireConnection;24;0;20;2
WireConnection;48;0;23;0
WireConnection;48;1;24;0
WireConnection;47;0;48;0
WireConnection;52;0;23;0
WireConnection;52;1;24;0
WireConnection;44;0;47;0
WireConnection;44;1;25;0
WireConnection;34;0;23;0
WireConnection;34;1;24;0
WireConnection;36;0;25;0
WireConnection;41;0;23;0
WireConnection;41;1;24;0
WireConnection;51;0;52;0
WireConnection;51;1;25;0
WireConnection;33;0;25;0
WireConnection;49;0;51;0
WireConnection;32;0;34;0
WireConnection;38;0;41;0
WireConnection;38;1;36;0
WireConnection;45;0;44;0
WireConnection;50;0;16;0
WireConnection;50;3;49;0
WireConnection;50;4;49;0
WireConnection;37;0;38;0
WireConnection;31;0;32;0
WireConnection;31;1;33;0
WireConnection;46;0;16;0
WireConnection;46;3;45;0
WireConnection;46;4;45;0
WireConnection;30;0;31;0
WireConnection;35;0;16;0
WireConnection;35;3;37;0
WireConnection;35;4;37;0
WireConnection;43;0;50;0
WireConnection;43;1;46;0
WireConnection;29;0;16;0
WireConnection;29;3;30;0
WireConnection;29;4;30;0
WireConnection;42;0;43;0
WireConnection;42;1;35;0
WireConnection;27;0;16;0
WireConnection;28;0;42;0
WireConnection;28;1;29;0
WireConnection;8;0;28;0
WireConnection;8;1;27;0
WireConnection;5;0;6;0
WireConnection;5;1;7;0
WireConnection;5;2;8;0
WireConnection;19;0;16;0
WireConnection;4;0;19;0
WireConnection;4;1;5;0
WireConnection;2;0;4;0
WireConnection;2;1;5;0
WireConnection;2;2;3;0
WireConnection;18;0;16;0
WireConnection;53;0;2;0
ASEEND*/
//CHKSM=39B1516CEDB92BB71893B0730B7CE248E7BDBDE4