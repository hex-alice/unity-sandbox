#define TEX(map, uv) tex2D(map, uv)

half InverseLerp(half from, half to, half value)
{
    return (value - from) / (to - from);
}

half InverseLerpClamp(half from, half to, half value)
{
    return saturate(InverseLerp(from, to, value));
}

half Ramp(half main, half rampValue)
{
    return floor(main * rampValue) / (rampValue - 1.0);
}

half Hash(half2 p)
{
    return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
}

half Fade(half t)
{
    return t * t * (3.0 - 2.0 * t);
}

half ValueNoise(half2 uv)
{
    half2 i = floor(uv);
    half2 f = frac(uv);

    half a = Hash(i);
    half b = Hash(i + half2(1.0, 0.0));
    half c = Hash(i + half2(0.0, 1.0));
    half d = Hash(i + half2(1.0, 1.0));

    half2 u = Fade(f);
    return lerp(lerp(a, b, u.x), lerp(c, d, u.x), u.y);
}

// Pseudo-random gradient vectors
half2 randomGradient(half2 p) {
    half angle = frac(sin(dot(p, half2(127.1, 311.7))) * 43758.5453) * 6.283185;
    return half2(cos(angle), sin(angle));
}

half Random(half2 uv)
{
    half2 i = floor(uv);
    half2 f = frac(uv);
    
    return frac(sin(dot(i, _DissolveRandomComparer.xy)) * _DissolveRandomMult);
}

// 2D Perlin Noise
float perlinNoise(half2 uv) {
    half2 i = floor(uv);
    half2 f = frac(uv);

    half2 g00 = randomGradient(i + half2(0.0, 0.0));
    half2 g10 = randomGradient(i + half2(1.0, 0.0));
    half2 g01 = randomGradient(i + half2(0.0, 1.0));
    half2 g11 = randomGradient(i + half2(1.0, 1.0));

    half2 d00 = f - half2(0.0, 0.0);
    half2 d10 = f - half2(1.0, 0.0);
    half2 d01 = f - half2(0.0, 1.0);
    half2 d11 = f - half2(1.0, 1.0);

    half n00 = dot(g00, d00);
    half n10 = dot(g10, d10);
    half n01 = dot(g01, d01);
    half n11 = dot(g11, d11);

    half2 u = Fade(f);
    half x1 = lerp(n00, n10, u.x);
    half x2 = lerp(n01, n11, u.x);

    return lerp(x1, x2, u.y);
}