Shader "Custom/Caustics"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness ("Smoothness", Range(0,1)) = 0.5
        _Metallic ("Metallic", Range(0,1)) = 0.0

        [Header(Caustics)]
        _CausticsTex("Caustics (RGB)", 2D) = "white" {}
    
        [Header(Caustics1)]

        _Caustics1_ST("Caustics 1 ST", Vector) = (1,1,0,0)
        _Caustics_Speed("Caustics 1 Speed", Vector) = (1, 1, 0 ,0)

        [Header(Caustics2)]
        _Caustics2_ST("Caustics 2 ST", Vector) = (1,1,0,0)
        _Caustics2_Speed("Caustics 2 Speed", Vector) = (1, 1, 0 ,0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        sampler2D _CausticsTex;

        float4 _Caustics1_ST;
        float4 _Caustics2_ST;

        float2 _Caustics1_Speed;
        float2 _Caustics2_Speed;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;

            fixed2 uv1 = IN.uv_MainTex * _Caustics1_ST.xy + _Caustics1_ST.zw;
            uv1 += _Caustics1_Speed * _Time.y;

            fixed3 c1 = tex2D(_CausticsTex, uv1).rgb;

            fixed2 uv2 = IN.uv_MainTex * _Caustics2_ST.xy + _Caustics2_ST.zw;
            uv2 += _Caustics2_Speed * _Time.y;

            fixed3 c2 = tex2D(_CausticsTex, uv2).rgb;

            o.Albedo.rgb += min(c1, c2);

            o.Metallic = _Metallic;
            o.Smoothness = _Glossiness;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
