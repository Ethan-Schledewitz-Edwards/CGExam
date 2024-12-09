Shader "Ethan/ScrollingShader"
{
     Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _ScrollUVX ("ScrollSpeedX", Range(0,10)) = 1
    }
    SubShader
    {
        Tags { "RenderPipeline" = "UniversalRenderPipeline"}
        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            struct Attributes
            {
                float4 vertex : POSITION; // Object space vertex position
                float2 uv : TEXCOORD0; // Texture coordinates
            };
            struct Varyings
            {
                float4 pos : SV_POSITION; // Clip space position
                float2 uv : TEXCOORD0; // UV coordinates passed to fragment shade
            };

            TEXTURE2D(_MainTex); // Main texture
            SAMPLER(sampler_MainTex); // Sampler for the texture
            float _ScrollUVX;

            // Vertex Shader
            Varyings vert(Attributes IN)
            {
                Varyings o;

                // Transform object space vertex to clip space
                o.pos = TransformObjectToHClip(IN.vertex.xyz);

                // Scale UVs and apply sine transformation
                o.uv = IN.uv;
                o.uv.x += _ScrollUVX * sin(_Time.x); // Scale and apply sine on X

                return o;
            }

            // Fragment Shader
            half4 frag(Varyings IN) : SV_Target
            {
               // Sample the main texture with transformed UV coordinates
               half4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv);

               return col;
            }
            ENDHLSL
        }
    }
}
