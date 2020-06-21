// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(typeof(TemplatesPostProcessStackPPSRenderer), PostProcessEvent.AfterStack, "1-Bit Post Process", true)]
public sealed class OneBitPP : PostProcessEffectSettings
{
}

public sealed class TemplatesPostProcessStackPPSRenderer : PostProcessEffectRenderer<OneBitPP>
{
	public override void Render(PostProcessRenderContext context)
	{
		var sheet = context.propertySheets.Get(Shader.Find("OneBitPP2"));
		context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
	}
}
#endif
