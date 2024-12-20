Shader "Ethan/PBalloon"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _SpecularColor("Specular Color", Color) = (1,1,1,1)
        _Shininess("Shininess", Range(1, 200)) = 50
        _Balloon ("Extrude", Range(0.0,1)) = 0.001
    }

    SubShader
    {
        Tags{ "RenderPipeline" = "UniversalRenderPipeline" }
        Pass 
        {

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"

            struct Attributes
            {
                float4 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionHCS : SV_POSITION;
                float3 normalWS : TEXCOORD0;
                float2 uv : TEXCOORD1;
                float3 viewDirWS : TEXCOORD2;
            };

            TEXTURE2D(_MainTex);
            SAMPLER(sampler_MainTex);
            float4 _SpecularColor;
            float _Shininess;
            float _Balloon;

            Varyings vert(Attributes IN)
            {
                Varyings OUT;

                // Extrude the vertex position along its normal
                float3 extrudedPosition = IN.positionOS.xyz + IN.normalOS * _Balloon;

                OUT.positionHCS = TransformObjectToHClip(extrudedPosition);

                OUT.normalWS = normalize(TransformObjectToWorldNormal(IN.normalOS));

                OUT.viewDirWS = normalize(GetWorldSpaceViewDir(extrudedPosition));
                OUT.uv = IN.uv;
                return OUT;
            }

            half4 frag(Varyings IN) : SV_Target
            {
                // Fetch the main light in URP
                Light mainLight = GetMainLight();
                half3 lightDir = normalize(mainLight.direction);

                // Normalize the world space normal
                half3 normalWS = normalize(IN.normalWS);

                // Diffuse Lighting
                half3 viewDir = normalize(IN.viewDirWS);
                half3 halfDir = normalize(lightDir + viewDir);
                half NdotL = saturate(dot(normalWS, lightDir));
                half NdotH = saturate(dot(normalWS, halfDir));


                // Specular 
                half specular = pow(NdotH, _Shininess);
                half3 specularColor = _SpecularColor.rgb * specular * mainLight.color;

                // Combine specular and diffuse components
                half3 diffuse = NdotL * mainLight.color;

                // Calculate ambient lighting
                half3 ambient = SampleSH(normalWS);

                // Sample the Texture
                half3 texColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, IN.uv).rgb;

                // Final COLOR
                half3 finalColor = texColor * (diffuse + specularColor + ambient);

                return half4(finalColor, 1.0);
            }
            ENDHLSL
        }
    }
}