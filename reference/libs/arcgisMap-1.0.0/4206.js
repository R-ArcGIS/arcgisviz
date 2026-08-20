"use strict";(self.webpackChunk=self.webpackChunk||[]).push([[3878,4206],{12668(e,t,r){r.d(t,{b:()=>G});var o=r(29785),a=r(77788),i=r(24615),n=r(31790),s=r(37716),l=r(65028),c=r(44418),d=r(3525),u=r(79887),h=r(51229),m=r(73713),p=r(83143),f=r(11255),v=r(70194),g=r(50710),x=r(87646),b=r(15850),y=r(40574),w=r(23605),M=r(75762),S=r(35212),T=r(65275),C=r(69563),I=r(69410),_=r(73349),P=r(79377),z=r(21586),D=r(64802),F=r(92121),R=r(19635),O=r(62462),j=r(19778),B=r(57777),H=r(73395),W=r(82315),E=r(43398),N=r(76221);function G(e){const t=new E.N5,{attributes:r,vertex:G,fragment:L,varyings:V}=t,{output:A,normalType:U,offsetBackfaces:k,spherical:$,snowCover:q,pbrMode:Z,textureAlphaPremultiplied:Y,instancedDoublePrecision:J,hasVertexColors:K,hasVertexTangents:X,hasColorTexture:Q,hasNormalTexture:ee,hasNormalTextureTransform:te,hasColorTextureTransform:re}=e;if((0,z.NB)(G,e),r.add("position","vec3"),G.inputs.add("position",()=>"position"),V.add("vpos","vec3",{invariant:!0}),t.include(I.A,e),t.include(l.B,e),t.include(f.Ge,e),t.include(C.q2,e),!(0,a._o)(A))return t.include(v.E,e),t;t.include(C.Sx,e),t.include(C.MU,e),t.include(C.O1,e),t.include(C.QM,e),(0,z.yu)(G,e),t.include(d.Y,e),t.include(n.d);const oe=0===U||1===U;return oe&&k&&t.include(o.M),t.include(g.J,e),t.include(p.Mh,e),t.include(s.v,e),V.add("vPositionLocal","vec3"),t.include(h.U,e),t.include(u.K,e),t.include(m.c,e),G.uniforms.add(new F.E("externalColor",e=>e.externalColor,{supportsNaN:!0})),V.add("vcolorExt","vec4"),G.include(c.WD),G.include(c.oF),t.include(J?T.QH:T.LA,e),G.main.add(O.H`
    forwardVertexColor();

    MaskedColor maskedColor =
      applySymbolColor(applyVVColor(applyInstanceColor(createMaskedFromNaNColor(externalColor))));

    vcolorExt = maskedColor.color;
    forwardColorMixMode(maskedColor.mask);

    vpos = getVertexInLocalOriginSpace();
    vPositionLocal = vpos - view[3].xyz;
    vpos = subtractOrigin(vpos);
    ${(0,O.If)(oe,"vNormalWorld = dpNormal(vvLocalNormal(normalModel()));")}
    vpos = addVerticalOffset(vpos, localOrigin);
    ${(0,O.If)(X,"vTangent = dpTransformVertexTangent(tangent);")}
    gl_Position = transformPosition(proj, view, vpos);
    ${(0,O.If)(oe&&k,"gl_Position = offsetBackfacingClipPosition(gl_Position, vpos, vNormalWorld, cameraPosition);")}

    forwardTextureCoordinates();
    forwardColorUV();
    forwardNormalUV();
    forwardEmissiveUV();
    forwardOcclusionUV();
    forwardMetallicRoughnessUV();

    if (opacityMixMode != ${O.H.int(H.Um.ignore)} && vcolorExt.a < ${O.H.float(N.Q)}) {
      gl_Position = vec4(1e38, 1e38, 1e38, 1.0);
    }
    forwardLinearDepthToReadShadowMap();
  `),L.include(b.kA,e),L.include(x.n,e),t.include(_.S,e),L.include(i.HQ,e),t.include(W.D,e),(0,z.yu)(L,e),L.uniforms.add(G.uniforms.get("localOrigin"),new D.t("ambient",e=>e.ambient),new D.t("diffuse",e=>e.diffuse),new R.m("opacity",e=>e.opacity),new R.m("layerOpacity",e=>e.layerOpacity)),Q&&L.uniforms.add(new j.N("tex",e=>e.texture)),t.include(S._,e),L.include(M.c,e),L.include(P.N),t.include(w.r,e),L.include(B.b,e),(0,b.a8)(L),(0,b.eU)(L),(0,y.O4)(L),L.main.add(O.H`
    discardBySlice(vpos);
    ${Q?O.H`
            vec4 texColor = texture(tex, ${re?"colorUV":"vuv0"});
            ${(0,O.If)(Y,"texColor.rgb /= texColor.a;")}
            discardOrAdjustAlpha(texColor);`:O.H`vec4 texColor = vec4(1.0);`}
    shadingParams.viewDirection = normalize(vpos - cameraPosition);
    ${2===U?O.H`vec3 normal = screenDerivativeNormal(vPositionLocal);`:O.H`shadingParams.normalView = vNormalWorld;
                vec3 normal = shadingNormal(shadingParams);`}
    applyPBRFactors();
    float ssao = evaluateAmbientOcclusionInverse() * getBakedOcclusion();

    vec3 posWorld = vpos + localOrigin;

    float additionalAmbientScale = additionalDirectedAmbientLight(posWorld);
    float shadow = readShadow(additionalAmbientScale, vpos);

    vec3 matColor = max(ambient, diffuse);
    vec3 albedo = mixExternalColor(${(0,O.If)(K,"vColor.rgb *")} matColor, texColor.rgb, vcolorExt.rgb, colorMixMode);
    float opacity_ = layerOpacity * mixExternalOpacity(${(0,O.If)(K,"vColor.a * ")} opacity, texColor.a, vcolorExt.a, opacityMixMode);

    ${ee?`mat3 tangentSpace = computeTangentSpace(${X?"normal":"normal, vpos, vuv0"});\n           vec3 shadingNormal = computeTextureNormal(tangentSpace, ${te?"normalUV":"vuv0"});`:"vec3 shadingNormal = normal;"}
    vec3 normalGround = ${$?"normalize(posWorld);":"vec3(0.0, 0.0, 1.0);"}

    ${(0,O.If)(q,O.H`
          float snow = getSnow(normal, normalGround);
          albedo = mix(albedo, vec3(1), snow);
          shadingNormal = mix(shadingNormal, normal, snow);
          ssao = mix(ssao, 1.0, snow);`)}

    vec3 additionalLight = ssao * mainLightIntensity * additionalAmbientScale * ambientBoostFactor * lightingGlobalFactor;

    ${1===Z||2===Z?O.H`
            float additionalAmbientIrradiance = additionalAmbientIrradianceFactor * mainLightIntensity[2];
            ${(0,O.If)(q,"mrr = applySnowToMRR(mrr, snow);")}
            vec3 shadedColor = evaluateSceneLightingPBR(shadingNormal, albedo, shadow, 1.0 - ssao, additionalLight, shadingParams.viewDirection, normalGround, mrr, additionalAmbientIrradiance);`:O.H`vec3 shadedColor = evaluateSceneLighting(shadingNormal, albedo, shadow, 1.0 - ssao, additionalLight);`}
    vec4 finalColor = vec4(shadedColor, opacity_);
    outputColorHighlightOLID(applySlice(finalColor, vpos), albedo ${(0,O.If)(q,", snow")});
  `),t}const L=Object.freeze(Object.defineProperty({__proto__:null,build:G},Symbol.toStringTag,{value:"Module"}));r.d(t,["D",0,L])},22950(e,t,r){r.d(t,{G:()=>g,c:()=>x});var o=r(50400),a=r(11422),i=r(56926),n=r(40574),s=r(10452),l=r(36288),c=r(19635),d=r(62462),u=r(7574),h=r(96384),m=r(19778),p=r(60577),f=(r(68716),r(13439)),v=r(43398);class g extends f.Y{constructor(){super(...arguments),this.projScale=1,this.scaleGlobalIllumination=1,this.accumulatedFrames=0,this.temporalSampleFrame=0,this.rayMarchMinReach=.15,this.rayMarchMaxReach=.5,this.rayMarchWorldReach=25,this.rayMarchMinReachEmissionWeight=1,this.rayMarchMaxReachEmissionWeight=1,this.rayMarchMaxSteps=16,this.colorBleedWeight=.15}}function x(e){const t=new v.N5,r=t.fragment;return t.include(o.c),t.include(l.Ir),(0,n.Gc)(r),r.include(a.V),r.include(i.C),r.include(p.R),t.include(s.O,e),r.uniforms.add(new m.N("normalMap",e=>e.normalTexture),new m.N("depthMap",e=>e.depthTexture),new h.x("lastFrameColorTexture",e=>e.reprojection.lastFrameColor?.getTexture()),new h.x("lastFrameDepthTexture",e=>e.reprojection.lastFrameDepth?.attachment),new h.x("lastFrameGlobalIlluminationTexture",e=>e.globalIllumination?.getTexture()),new h.x("lastFrameGlobalIlluminationWeightTexture",e=>e.globalIllumination?.getTexture(36065)),new u.F("reprojectionViewMatrix",e=>e.reprojection.viewMatrix),new u.F("view",e=>e.camera.viewMatrix),new c.m("accumulatedFrames",e=>e.accumulatedFrames),new c.m("temporalSampleFrame",e=>e.temporalSampleFrame),new c.m("scaleGlobalIllumination",e=>e.scaleGlobalIllumination)),r.uniforms.add(new c.m("rayMarchMinReach",e=>e.rayMarchMinReach),new c.m("rayMarchMaxReach",e=>e.rayMarchMaxReach),new c.m("rayMarchWorldReach",e=>e.rayMarchWorldReach),new c.m("rayMarchMinReachEmissionWeight",e=>e.rayMarchMinReachEmissionWeight),new c.m("rayMarchMaxReachEmissionWeight",e=>e.rayMarchMaxReachEmissionWeight),new c.m("rayMarchMaxSteps",e=>e.rayMarchMaxSteps),new c.m("colorBleedWeight",e=>e.colorBleedWeight)),e.hasEmission&&r.uniforms.add(new h.x("lastFrameEmissionTexture",e=>e.reprojection.lastFrameEmission?.attachment)),r.code.add(d.H`
    float computeIdleColorBlendWeight(float accumulatedFrames) {
      float idleColorBlendProgress = clamp(
        accumulatedFrames / ${d.H.float(40)},
        0.0,
        1.0
      );
      return mix(
        ${d.H.float(.012)},
        ${d.H.float(.008)},
        idleColorBlendProgress
      );
    }

    float computeIdleOcclusionBlendWeight(float accumulatedFrames) {
      float idleOcclusionBlendProgress = clamp(
        accumulatedFrames / ${d.H.float(60)},
        0.0,
        1.0
      );
      return mix(
        ${d.H.float(.095)},
        ${d.H.float(.008)},
        pow(idleOcclusionBlendProgress, ${d.H.float(2)})
      );
    }

    bool isEdgeDepth(float centerDepth, vec2 sampleUv) {
      vec2 texelSize = 1.0 / vec2(textureSize(depthMap, 0));
      float depthLeft = linearizeDepth(depthFromTexture(depthMap, sampleUv + vec2(-texelSize.x, 0.0)));
      float depthRight = linearizeDepth(depthFromTexture(depthMap, sampleUv + vec2(texelSize.x, 0.0)));
      float depthUp = linearizeDepth(depthFromTexture(depthMap, sampleUv + vec2(0.0, texelSize.y)));
      float depthDown = linearizeDepth(depthFromTexture(depthMap, sampleUv + vec2(0.0, -texelSize.y)));

      float maxDifference = max(max(abs(centerDepth - depthLeft), abs(centerDepth - depthRight)), max(abs(centerDepth - depthUp), abs(centerDepth - depthDown)));

      return abs(maxDifference / centerDepth) > 0.01;
    }

    vec3 sampleCosineHemisphere(vec2 u) {
      float phi = 6.28318530718 * u.x;
      float radius = sqrt(u.y);
      float x = radius * cos(phi);
      float y = radius * sin(phi);
      float z = sqrt(max(0.0, 1.0 - u.y));

      return vec3(x, y, z);
    }

    mat3 basisFromNormal(vec3 n) {
      vec3 up = abs(n.z) < 0.999 ? vec3(0.0, 0.0, 1.0) : vec3(1.0, 0.0, 0.0);
      vec3 tangent = normalize(cross(up, n));
      vec3 bitangent = cross(n, tangent);

      return mat3(tangent, bitangent, n);
    }

    float blueNoiseDitherValue(vec2 pixel, float frame, vec2 axis, float phase) {
      float scroll = 5.588238 * mod(frame, 512.0);
      vec2 p = pixel + vec2(scroll);
      vec2 rotated = vec2(
        axis.x * p.x + axis.y * p.y,
        -axis.y * p.x + axis.x * p.y
      );

      return fract(52.9829189 * fract(0.06711056 * rotated.x + 0.00583715 * rotated.y + phase));
    }

    vec4 blueNoiseDither(vec2 pixel, float frame) {
      vec4 value = vec4(
        blueNoiseDitherValue(pixel, frame, vec2(0.9659258, 0.25881904), 0.0),
        blueNoiseDitherValue(pixel, frame, vec2(0.70710677, 0.70710677), 0.17),
        blueNoiseDitherValue(pixel, frame, vec2(0.25881904, 0.9659258), 0.37),
        blueNoiseDitherValue(pixel, frame, vec2(1.0, 0.0), 0.61)
      );

      return value * 2.0 - 1.0;
    }
  `),t.outputs.add("fragGlobalIllumination","vec4",0),t.outputs.add("fragWeight","float",1),r.main.add(d.H`
    float depth = depthFromTexture(depthMap, uv);

    // Early out if depth is out of range, such as in the sky
    if (depth >= 1.0 || depth <= 0.0) {
      fragGlobalIllumination = vec4(0.0, 0.0, 0.0, 1.0);
      fragWeight = 0.0;
      return;
    }

    // Get the normal of current fragment
    ivec2 iuv = ivec2(uv * vec2(textureSize(normalMap, 0)));
    vec4 normal4 = texelFetch(normalMap, iuv, 0);
    if (normal4.a != 1.0) {
      fragGlobalIllumination = vec4(0.0, 0.0, 0.0, 1.0);
      fragWeight = 0.0;
      return;
    }
    vec3 normal = normalize(normal4.xyz * 2.0 - 1.0);

    // Reconstruct view space position of current fragment
    float currentPixelDepth = linearizeDepth(depth);
    vec3 currentPixelPos = reconstructPosition(uv * vec2(textureSize(normalMap, 0)), currentPixelDepth);
    vec4 viewPos = vec4(currentPixelPos, 1.0);

    // Reproject current view position to last frame
    vec4 reprojectedViewPos = reprojectionViewMatrix * viewPos;
    vec4 reprojectedCoordinate = applyProjectionMat(proj, reprojectedViewPos.xyz);

    // Read last frame reprojected depth and GI history
    float lastFrameDepthViewPos = -linearDepthFromTextureLastFrame(lastFrameDepthTexture, reprojectedCoordinate.xy);
    vec4 lastFrameGlobalIllumination = texture(lastFrameGlobalIlluminationTexture, reprojectedCoordinate.xy);
    float historyOcclusionBlendWeight = texture(lastFrameGlobalIlluminationWeightTexture, reprojectedCoordinate.xy).r;

    int steps;
    float occlusionBlendWeight = 1.0;
    float colorBlendWeight = 1.0;
    float idleColorBlendWeight = computeIdleColorBlendWeight(accumulatedFrames);
    float idleOcclusionBlendWeight = computeIdleOcclusionBlendWeight(accumulatedFrames);
    float reprojectionDepthMismatch = abs((lastFrameDepthViewPos + reprojectedViewPos.z) / max(lastFrameDepthViewPos, reprojectedViewPos.z));
    bool hasReprojectionMismatch = reprojectionDepthMismatch > ${d.H.float(.01)};
    bool isScaledGlobalIllumination = scaleGlobalIllumination < 1.0;
    bool isLowQualityEdgePixel = isScaledGlobalIllumination && isEdgeDepth(currentPixelDepth, uv);
    bool resetColorHistory = false;

    // Heuristic to determine blending weights and number of steps for occlusion and color
    if (hasReprojectionMismatch) {
      if (isLowQualityEdgePixel) {
        steps = 1;
        occlusionBlendWeight = ${d.H.float(.008)};
        resetColorHistory = true;
      } else {
        steps = 6;
        occlusionBlendWeight = 1.0;
        resetColorHistory = true;
      }
    } else {
      steps = 1;
      if (historyOcclusionBlendWeight > ${d.H.float(.5)}) {
        occlusionBlendWeight = ${d.H.float(.1)};
        colorBlendWeight = ${d.H.float(.008)};
      } else if (historyOcclusionBlendWeight > ${d.H.float(.02)}) {
        occlusionBlendWeight = historyOcclusionBlendWeight - 0.05;
        colorBlendWeight = ${d.H.float(.008)};
      } else {
        occlusionBlendWeight = isScaledGlobalIllumination ? ${d.H.float(.008)} : idleOcclusionBlendWeight;
        colorBlendWeight = isScaledGlobalIllumination ? ${d.H.float(.002)} : idleColorBlendWeight;
      }
    }

    vec4 randomDirectionSample;
    mat3 normalBasis = basisFromNormal(normal);
    int temporalSampleStride = min(64 / steps, 6);
    float temporalFrameOffset = mod(temporalSampleFrame, float(64 / steps));

    // For each ray determine if it hits geometry and accumulate occlusion or color
    float stepSize = 1.0 / float(steps);
    for (int i = 0; i < steps; ++i) {
      float sampleIndex = float(i * temporalSampleStride + int(temporalFrameOffset));
      randomDirectionSample = blueNoiseDither(floor(gl_FragCoord.xy), sampleIndex);
      vec2 hemisphereSample = randomDirectionSample.rg * 0.5 + 0.5;
      float offsetSample = randomDirectionSample.a * 0.5 + 0.5;
      vec3 rayDirection = normalBasis * sampleCosineHemisphere(hemisphereSample);
      float rayMarchScreenReach = rayMarchScreenReachFromWorldReach(viewPos.xyz, rayDirection, rayMarchWorldReach);
      rayMarchScreenReach = clamp(rayMarchScreenReach, rayMarchMinReach, rayMarchMaxReach);
      vec3 hit = screenSpaceIntersectionWithLimits(
        rayDirection,
        viewPos.xyz,
        normalize(viewPos.xyz),
        normal,
        offsetSample,
        rayMarchScreenReach,
        rayMarchMaxSteps
      );

      if (hit.z > 0.0) {
        ${(0,d.If)(e.hasColor,d.H`
          // Emission and color bleed - Reproject the current receiver and sampled hit to estimate bounced color
          vec3 receiverColor = texture(lastFrameColorTexture, reprojectedCoordinate.xy).rgb;

          vec2 hitReprojectedCoordinate = reprojectionCoordinate(hit);
          vec3 sourceColor = texture(lastFrameColorTexture, hitReprojectedCoordinate).rgb;
          vec3 sourceColorLinear = linearizeGamma(sourceColor);
          vec3 sourceEmission = ${(0,d.If)(e.hasEmission,"texture(lastFrameEmissionTexture, hitReprojectedCoordinate).xyz","vec3(0.0)")};

          float emissionWeight = mix(
            rayMarchMinReachEmissionWeight,
            rayMarchMaxReachEmissionWeight,
            (rayMarchScreenReach - rayMarchMinReach) / max(rayMarchMaxReach - rayMarchMinReach, 0.00001)
          );
          fragGlobalIllumination.rgb += ((sourceColorLinear * colorBleedWeight) + sourceEmission * emissionWeight) * stepSize;
          `)}
      } else {
        // Occlusion - heuristic modulating sky intensity based on angle to main light
        vec4 viewMainLightDirection = view * vec4(mainLightDirection, 0.0);
        float skyModulation = pow(max(dot(rayDirection, viewMainLightDirection.xyz), 0.0), 3.0) * 5.5;
        float skyFacingWeight = clamp(3.5 * dot(viewMainLightDirection.xyz, normal), 0.0, 1.0);
        skyModulation = mix(1.0, skyModulation * 0.2 + 0.8, skyFacingWeight);
        fragGlobalIllumination.a += skyModulation * stepSize;
      }
    }

    // Rendering trick add noise to reduce accumulation artifacts
    float accumulationDither = occlusionBlendWeight < 1.0
      ? randomDirectionSample.b * ${d.H.float(.0039)}
      : 0.0;

    ${(0,d.If)(e.hasColor,d.H`
      // Accumulate color
      vec3 lastFrameColor = lastFrameGlobalIllumination.rgb;
      float colorDitherScale = isScaledGlobalIllumination ? ${d.H.float(.25)} : 1.0;
      fragGlobalIllumination.rgb = resetColorHistory
        ? vec3(0.0)
        : mix(lastFrameColor + accumulationDither * colorDitherScale, fragGlobalIllumination.rgb, colorBlendWeight);
      `,d.H`
      fragGlobalIllumination.rgb = vec3(0.0);
      `)}
    fragGlobalIllumination.rgb = quantizeGlobalIlluminationColor(fragGlobalIllumination.rgb);

    // Accumulate occlusion
    fragGlobalIllumination.a = mix(lastFrameGlobalIllumination.a + accumulationDither, fragGlobalIllumination.a, occlusionBlendWeight);

    fragWeight = occlusionBlendWeight;
  `),t}const b=Object.freeze(Object.defineProperty({__proto__:null,GlobalIlluminationPassParameters:g,build:x,defaultColorBleedWeight:.15,defaultRayMarchMaxReach:.5,defaultRayMarchMaxReachEmissionWeight:1,defaultRayMarchMaxSteps:16,defaultRayMarchMinReach:.15,defaultRayMarchMinReachEmissionWeight:1,defaultRayMarchWorldReach:25},Symbol.toStringTag,{value:"Module"}));r.d(t,["a",0,b])},37809(e,t,r){r.d(t,{G:()=>b,b:()=>y});var o=r(56560),a=r(50400),i=r(16937),n=r(49874),s=r(36288),l=r(70483),c=r(37138),d=r(19635),u=r(62462),h=r(29247),m=r(19778),p=r(60577),f=r(71038),v=r(41414),g=r(13439),x=r(43398);class b extends g.Y{constructor(){super(...arguments),this.blurSize=(0,o.vt)()}}function y(){const e=new x.N5,t=e.fragment;e.include(a.c),e.include(s.Ir),e.include(n.Q);return t.include(i.E),t.include(f.t,w),t.include(p.R),t.uniforms.add(new l.o("hasEmission",e=>e.hasEmission),new m.N("depthMap",e=>e.depthTexture),new m.N("normalMap",e=>e.normalTexture),new h.o("globalIlluminationTexture",e=>e.texture),new h.o("globalIlluminationWeightTexture",e=>e.weightTexture),new c.t("blurSize",e=>e.blurSize),new d.m("scaleGlobalIllumination",e=>e.scaleGlobalIllumination),new d.m("projScale",(e,t)=>{const r=t.camera.distance;return r>5e4?Math.max(0,e.projScale-(r-5e4)):e.projScale})),t.code.add(u.H`
    void accumulateBlurSample(
      vec2 sampleUv,
      float sampleOffset,
      float centerDepth,
      vec3 centerNormal,
      float depthSharpness,
      bool skipOcclusionBlur,
      inout float emissionWeightSum,
      inout vec3 emissionSum,
      inout float occlusionWeightSum,
      inout float occlusionSum,
      float centerOcclusionBlendWeight
    ) {
      vec4 sampleGlobalIllumination = texture(globalIlluminationTexture, sampleUv);
      vec3 sampleNormal = texture(normalMap, sampleUv).rgb;
      float sampleDepth = linearDepthFromTexture(depthMap, sampleUv);

      float depthDelta = sampleDepth - centerDepth;
      bool isScaledGlobalIllumination = scaleGlobalIllumination < 1.0;
      float normalSimilarityWeight = globalIlluminationNormalSimilarityWeight(sampleNormal, centerNormal);
      float depthNormalCorrection = globalIlluminationDepthNormalCorrection(sampleNormal);
      vec3 emission = sampleGlobalIllumination.rgb;
      float emissionSpatialWeightMultiplier = isScaledGlobalIllumination ? ${u.H.float(400)} : 1.0;

      float emissionWeight = exp(
        -sampleOffset * sampleOffset * ${u.H.float(1/24.5)} * ${u.H.float(.1)} * emissionSpatialWeightMultiplier
        - depthDelta * depthDelta * depthSharpness * depthNormalCorrection
      );
      emissionWeight *= normalSimilarityWeight;
      emissionWeightSum += emissionWeight;
      emissionSum += emissionWeight * emission;

      if (skipOcclusionBlur) {
        return;
      }

      float occlusionSpatialKernelScale = centerOcclusionBlendWeight > ${u.H.float(.03)}
        ? ${u.H.float(.08)}
        : ${u.H.float(1.5)};
      float occlusionWeight = exp(-sampleOffset * sampleOffset * occlusionSpatialKernelScale - depthDelta * depthDelta * depthSharpness);
      occlusionWeight *= normalSimilarityWeight;
      occlusionWeightSum += occlusionWeight;
      occlusionSum += occlusionWeight * sampleGlobalIllumination.a;
    }
  `),t.main.add(u.H`
    vec3 emissionSum = vec3(0.0);
    float emissionWeightSum = 0.0;

    vec4 centerGlobalIllumination = texture(globalIlluminationTexture, uv);
    float centerOcclusionBlendWeight = texture(globalIlluminationWeightTexture, uv).r;
    bool isScaledGlobalIllumination = scaleGlobalIllumination < 1.0;
    bool shouldReuseCenterOcclusion = isScaledGlobalIllumination && centerOcclusionBlendWeight <= ${u.H.float(.03)};
    bool shouldSkipLowQualityBlur = !hasEmission && shouldReuseCenterOcclusion;
    if (shouldSkipLowQualityBlur) {
      fragColor = vec4(
        quantizeGlobalIlluminationColor(centerGlobalIllumination.rgb),
        centerGlobalIllumination.a
      );
      return;
    }

    float centerDepth = linearDepthFromTexture(depthMap, uv);
    vec3 centerNormal = texture(normalMap, uv).rgb;
    float occlusionSum = 0.0;
    float occlusionWeightSum = 0.0;

    float depthSharpness = globalIlluminationDepthSharpness(projScale, centerDepth);
    for (int sampleOffset = -${u.H.int(4)}; sampleOffset <= ${u.H.int(4)}; ++sampleOffset) {
      float sampleOffsetFloat = float(sampleOffset);
      vec2 sampleUv = uv + sampleOffsetFloat * blurSize;
      accumulateBlurSample(
        sampleUv,
        sampleOffsetFloat,
        centerDepth,
        centerNormal,
        depthSharpness,
        shouldReuseCenterOcclusion,
        emissionWeightSum,
        emissionSum,
        occlusionWeightSum,
        occlusionSum,
        centerOcclusionBlendWeight
      );
    }

    float occlusion = shouldReuseCenterOcclusion ? centerGlobalIllumination.a : occlusionSum / occlusionWeightSum;
    vec3 blurredEmission = (emissionSum / emissionWeightSum).rgb;

    // heuristic dithering of the colors to remove banding, color shifts and wrong color accumulation
    float dither = ditherNoise(vec4(blurredEmission, occlusion)) - 1./32768.0;
    blurredEmission += isScaledGlobalIllumination ? 0.85 * dither : dither;

    fragColor = vec4(quantizeGlobalIlluminationColor(blurredEmission), occlusion);
  `),e}const w=new v.Tt;w.useFloatBlend=!1;const M=Object.freeze(Object.defineProperty({__proto__:null,GlobalIlluminationBlurDrawParameters:b,build:y},Symbol.toStringTag,{value:"Module"}));r.d(t,["a",0,M])},27351(e,t,r){r.d(t,{G:()=>p,b:()=>f});var o=r(50400),a=r(16937),i=r(49874),n=r(36288),s=r(19635),l=r(62462),c=r(29247),d=r(19778),u=r(60577),h=r(13439),m=r(43398);class p extends h.Y{}function f(){const e=new m.N5,t=e.fragment;return e.include(o.c),e.include(n.Ir),e.include(i.Q),t.include(a.E),t.include(u.R),t.uniforms.add(new d.N("depthMap",e=>e.depthTexture),new d.N("normalMap",e=>e.normalTexture),new c.o("tex",e=>e.colorTexture),new c.o("globalIlluminationWeightTexture",e=>e.weightTexture),new s.m("projScale",(e,t)=>{const r=t.camera.distance;return r>5e4?Math.max(0,e.projScale-(r-5e4)):e.projScale})),t.code.add(l.H`
    float computeDepthWeight(float sampleDepth, float centerDepth, float depthSharpness) {
      float depthDelta = abs(sampleDepth - centerDepth);
      return exp(-0.08 - depthDelta * depthDelta * depthSharpness);
    }

    vec3 normalFromTexture(sampler2D normalTexture, vec2 uv) {
      ivec2 normalTextureSize = textureSize(normalTexture, 0);
      ivec2 normalTexel = clamp(ivec2(uv * vec2(normalTextureSize)), ivec2(0), normalTextureSize - ivec2(1));
      return texelFetch(normalTexture, normalTexel, 0).xyz;
    }

    void sampleJointBilateralUpscale(vec2 sampleUv, out vec4 upscaledColor, out float upscaledWeight) {
      float centerDepth = linearDepthFromTexture(depthMap, sampleUv);
      vec3 centerNormal = normalFromTexture(normalMap, sampleUv);
      float depthSharpness = ${l.H.float(100)} * globalIlluminationDepthSharpness(projScale, centerDepth, centerNormal);

      vec2 lowResTextureSize = vec2(textureSize(tex, 0));
      vec2 texelPosition = sampleUv * lowResTextureSize - 0.5;
      vec2 texelBase = floor(texelPosition);
      vec2 bilinearWeightsFraction = fract(texelPosition);

      vec2 uv00 = (texelBase + vec2(0.5, 0.5)) / lowResTextureSize;
      vec2 uv10 = (texelBase + vec2(1.5, 0.5)) / lowResTextureSize;
      vec2 uv01 = (texelBase + vec2(0.5, 1.5)) / lowResTextureSize;
      vec2 uv11 = (texelBase + vec2(1.5, 1.5)) / lowResTextureSize;

      vec4 color00 = texture(tex, uv00);
      vec4 color10 = texture(tex, uv10);
      vec4 color01 = texture(tex, uv01);
      vec4 color11 = texture(tex, uv11);
      float weight00 = texture(globalIlluminationWeightTexture, uv00).r;
      float weight10 = texture(globalIlluminationWeightTexture, uv10).r;
      float weight01 = texture(globalIlluminationWeightTexture, uv01).r;
      float weight11 = texture(globalIlluminationWeightTexture, uv11).r;

      float depth00 = linearDepthFromTexture(depthMap, uv00);
      float depth10 = linearDepthFromTexture(depthMap, uv10);
      float depth01 = linearDepthFromTexture(depthMap, uv01);
      float depth11 = linearDepthFromTexture(depthMap, uv11);

      vec3 normal00 = normalFromTexture(normalMap, uv00);
      vec3 normal10 = normalFromTexture(normalMap, uv10);
      vec3 normal01 = normalFromTexture(normalMap, uv01);
      vec3 normal11 = normalFromTexture(normalMap, uv11);

      float bilinearWeight00 = (1.0 - bilinearWeightsFraction.x) * (1.0 - bilinearWeightsFraction.y);
      float bilinearWeight10 = bilinearWeightsFraction.x * (1.0 - bilinearWeightsFraction.y);
      float bilinearWeight01 = (1.0 - bilinearWeightsFraction.x) * bilinearWeightsFraction.y;
      float bilinearWeight11 = bilinearWeightsFraction.x * bilinearWeightsFraction.y;

      float jointBilateralWeight00 = bilinearWeight00 * computeDepthWeight(depth00, centerDepth, depthSharpness) * globalIlluminationNormalSimilarityWeight(normal00, centerNormal);
      float jointBilateralWeight10 = bilinearWeight10 * computeDepthWeight(depth10, centerDepth, depthSharpness) * globalIlluminationNormalSimilarityWeight(normal10, centerNormal);
      float jointBilateralWeight01 = bilinearWeight01 * computeDepthWeight(depth01, centerDepth, depthSharpness) * globalIlluminationNormalSimilarityWeight(normal01, centerNormal);
      float jointBilateralWeight11 = bilinearWeight11 * computeDepthWeight(depth11, centerDepth, depthSharpness) * globalIlluminationNormalSimilarityWeight(normal11, centerNormal);
      float jointBilateralWeightSum = jointBilateralWeight00 + jointBilateralWeight10 + jointBilateralWeight01 + jointBilateralWeight11;

      if (jointBilateralWeightSum < 0.0001) {
        // Fall back to the nearest low-resolution texel when all bilateral weights collapse.
        vec2 nearestUv = (floor(texelPosition + 0.5) + vec2(0.5)) / lowResTextureSize;
        upscaledColor = texture(tex, nearestUv);
        upscaledWeight = texture(globalIlluminationWeightTexture, nearestUv).r;
        return;
      }

      upscaledColor = (
        color00 * jointBilateralWeight00 +
        color10 * jointBilateralWeight10 +
        color01 * jointBilateralWeight01 +
        color11 * jointBilateralWeight11
      ) / jointBilateralWeightSum;

      upscaledWeight = (
        weight00 * jointBilateralWeight00 +
        weight10 * jointBilateralWeight10 +
        weight01 * jointBilateralWeight01 +
        weight11 * jointBilateralWeight11
      ) / jointBilateralWeightSum;
    }
  `),e.outputs.add("fragColor","vec4",0),e.outputs.add("fragWeight","float",1),t.main.add(l.H`sampleJointBilateralUpscale(uv, fragColor, fragWeight);
fragColor.rgb = quantizeGlobalIlluminationColor(fragColor.rgb);`),e}const v=Object.freeze(Object.defineProperty({__proto__:null,GlobalIlluminationUpscaleDrawParameters:p,build:f},Symbol.toStringTag,{value:"Module"}));r.d(t,["a",0,v])},38716(e,t,r){r.d(t,{b:()=>W});var o=r(29785),a=r(77788),i=r(24615),n=r(31790),s=r(37716),l=r(65028),c=r(44418),d=r(3525),u=r(79887),h=r(51229),m=r(73713),p=r(11255),f=r(70194),v=r(87646),g=r(15850),x=r(40574),b=r(75762),y=r(35212),w=r(65275),M=r(69563),S=r(69410),T=r(73349),C=r(79377),I=r(21586),_=r(64802),P=r(92121),z=r(19635),D=r(62462),F=r(19778),R=r(57777),O=r(73395),j=r(92703),B=r(82315),H=r(43398);function W(e){const t=new H.N5,{attributes:r,vertex:W,fragment:E,varyings:N}=t,{output:G,offsetBackfaces:L,pbrMode:V,snowCover:A,spherical:U}=e,k=1===V||2===V;if((0,I.NB)(W,e),r.add("position","vec3"),W.inputs.add("position",()=>"position"),N.add("vpos","vec3",{invariant:!0}),t.include(S.A,e),t.include(l.B,e),t.include(p.Ge,e),t.include(M.q2,e),!(0,a._o)(G))return t.include(f.E,e),t;t.include(M.MU,e),(0,I.yu)(t.vertex,e),t.include(d.Y,e),t.include(n.d),L&&t.include(o.M),N.add("vNormalWorld","vec3"),N.add("localvpos","vec3",{invariant:!0}),t.include(h.U,e),t.include(u.K,e),t.include(s.v,e),t.include(m.c,e),W.include(c.WD),W.include(c.oF),W.uniforms.add(new P.E("externalColor",e=>e.externalColor,{supportsNaN:!0})),N.add("vcolorExt","vec4"),t.include(e.instancedDoublePrecision?w.QH:w.LA,e),W.include(j.Q),W.main.add(D.H`
    forwardVertexColor();

    MaskedColor maskedColorExt =
      applySymbolColor(applyVVColor(applyInstanceColor(createMaskedFromNaNColor(externalColor))));

    vcolorExt = maskedColorExt.color;
    forwardColorMixMode(maskedColorExt.mask);

    bool alphaCut = opacityMixMode != ${D.H.int(O.Um.ignore)} && vcolorExt.a < alphaCutoff;
    vpos = getVertexInLocalOriginSpace();

    localvpos = vpos - view[3].xyz;
    vpos = subtractOrigin(vpos);
    vNormalWorld = dpNormal(vvLocalNormal(normalModel()));
    vpos = addVerticalOffset(vpos, localOrigin);
    vec4 basePosition = transformPosition(proj, view, vpos);

    forwardTextureCoordinates();
    forwardColorUV();
    forwardEmissiveUV();
    forwardLinearDepthToReadShadowMap();
    gl_Position = alphaCut ? vec4(1e38, 1e38, 1e38, 1.0) :
    ${(0,D.If)(L,"offsetBackfacingClipPosition(basePosition, vpos, vNormalWorld, cameraPosition);","basePosition;")}
  `);const{hasColorTexture:$,hasColorTextureTransform:q}=e;return E.include(g.kA,e),E.include(v.n,e),t.include(T.S,e),E.include(i.HQ,e),t.include(B.D,e),(0,I.yu)(E,e),(0,x.Gc)(E),(0,g.a8)(E),(0,g.eU)(E),E.uniforms.add(W.uniforms.get("localOrigin"),W.uniforms.get("view"),new _.t("ambient",e=>e.ambient),new _.t("diffuse",e=>e.diffuse),new z.m("opacity",e=>e.opacity),new z.m("layerOpacity",e=>e.layerOpacity)),$&&E.uniforms.add(new F.N("tex",e=>e.texture)),t.include(y._,e),E.include(b.c,e),E.include(C.N),E.include(R.b,e),(0,x.O4)(E),E.main.add(D.H`
      discardBySlice(vpos);
      vec4 texColor = ${$?`texture(tex, ${q?"colorUV":"vuv0"})`:" vec4(1.0)"};
      ${(0,D.If)($,`${(0,D.If)(e.textureAlphaPremultiplied,"texColor.rgb /= texColor.a;")}\n        discardOrAdjustAlpha(texColor);`)}
      vec3 viewDirection = normalize(vpos - cameraPosition);
      applyPBRFactors();
      float ssao = evaluateAmbientOcclusionInverse();
      ssao *= getBakedOcclusion();

      float additionalAmbientScale = additionalDirectedAmbientLight(vpos + localOrigin);
      vec3 additionalLight = ssao * mainLightIntensity * additionalAmbientScale * ambientBoostFactor * lightingGlobalFactor;
      float shadow = readShadow(additionalAmbientScale, vpos);
      vec3 matColor = max(ambient, diffuse);
      ${e.hasVertexColors?D.H`vec3 albedo = mixExternalColor(vColor.rgb * matColor, texColor.rgb, vcolorExt.rgb, colorMixMode);
             float opacity_ = layerOpacity * mixExternalOpacity(vColor.a * opacity, texColor.a, vcolorExt.a, opacityMixMode);`:D.H`vec3 albedo = mixExternalColor(matColor, texColor.rgb, vcolorExt.rgb, colorMixMode);
             float opacity_ = layerOpacity * mixExternalOpacity(opacity, texColor.a, vcolorExt.a, opacityMixMode);`}

      vec3 shadingNormal = normalize(vNormalWorld);
      vec3 groundNormal = ${U?"normalize(vpos + localOrigin)":"vec3(0.0, 0.0, 1.0)"};

      ${(0,D.If)(A,"vec3 faceNormal = screenDerivativeNormal(vpos);\n         float snow = getRealisticTreeSnow(faceNormal, shadingNormal, groundNormal);\n         albedo = mix(albedo, vec3(1), snow);")}

      ${D.H`albedo *= 1.2;
             vec3 viewForward = vec3(view[0][2], view[1][2], view[2][2]);
             float alignmentLightView = clamp(dot(viewForward, -mainLightDirection), 0.0, 1.0);
             float transmittance = 1.0 - clamp(dot(viewForward, shadingNormal), 0.0, 1.0);
             float treeRadialFalloff = vColor.r;
             float backLightFactor = 0.5 * treeRadialFalloff * alignmentLightView * transmittance * (1.0 - shadow);
             additionalLight += backLightFactor * mainLightIntensity;`}

      ${k?D.H`float additionalAmbientIrradiance = additionalAmbientIrradianceFactor * mainLightIntensity[2];
            ${(0,D.If)(A,"mrr = applySnowToMRR(mrr, snow);")}
            vec3 shadedColor = evaluateSceneLightingPBR(shadingNormal, albedo, shadow, 1.0 - ssao, additionalLight, viewDirection, groundNormal, mrr, additionalAmbientIrradiance);`:D.H`vec3 shadedColor = evaluateSceneLighting(shadingNormal, albedo, shadow, 1.0 - ssao, additionalLight);`}
      vec4 finalColor = vec4(shadedColor, opacity_);
      outputColorHighlightOLID(applySlice(finalColor, vpos), albedo ${(0,D.If)(A,", 1.0")});`),t}const E=Object.freeze(Object.defineProperty({__proto__:null,build:W},Symbol.toStringTag,{value:"Module"}));r.d(t,["R",0,E])},43300(e,t,r){r.d(t,{b:()=>v,g:()=>g});var o=r(53334),a=r(56560),i=r(50400),n=r(16937),s=r(56926),l=r(36288),c=r(33),d=r(66579),u=r(41281),h=r(19635),m=r(62462),p=r(19778),f=r(43398);function v(){const e=new f.N5,t=e.fragment;return e.include(i.c),e.include(l.Ir),t.include(n.E),t.include(s.C),t.uniforms.add(new u.U("radius",e=>g(e.camera))).code.add(m.H`vec3 sphere[16] = vec3[16](
vec3(0.186937, 0.0, 0.0),
vec3(0.700542, 0.0, 0.0),
vec3(-0.864858, -0.481795, -0.111713),
vec3(-0.624773, 0.102853, -0.730153),
vec3(-0.387172, 0.260319, 0.007229),
vec3(-0.222367, -0.642631, -0.707697),
vec3(-0.01336, -0.014956, 0.169662),
vec3(0.122575, 0.1544, -0.456944),
vec3(-0.177141, 0.85997, -0.42346),
vec3(-0.131631, 0.814545, 0.524355),
vec3(-0.779469, 0.007991, 0.624833),
vec3(0.308092, 0.209288,0.35969),
vec3(0.359331, -0.184533, -0.377458),
vec3(0.192633, -0.482999, -0.065284),
vec3(0.233538, 0.293706, -0.055139),
vec3(0.417709, -0.386701, 0.442449)
);
float fallOffFunction(float vv, float vn, float bias) {
float f = max(radius * radius - vv, 0.0);
return f * f * f * max(vn - bias, 0.0);
}`),t.code.add(m.H`float aoValueFromPositionsAndNormal(vec3 C, vec3 n_C, vec3 Q) {
vec3 v = Q - C;
float vv = dot(v, v);
float vn = dot(normalize(v), n_C);
return fallOffFunction(vv, vn, 0.1);
}`),e.outputs.add("fragOcclusion","float"),t.uniforms.add(new p.N("normalMap",e=>e.normalTexture),new p.N("depthMap",e=>e.depthTexture),new h.m("projScale",e=>e.projScale),new p.N("rnm",e=>e.noiseTexture),new d.G("rnmScale",(e,t)=>(0,o.hZ)(x,t.camera.fullWidth/e.noiseTexture.descriptor.width,t.camera.fullHeight/e.noiseTexture.descriptor.height)),new h.m("intensity",e=>e.intensity),new c.E("screenSize",e=>(0,o.hZ)(x,e.camera.fullWidth,e.camera.fullHeight))).main.add(m.H`
    float depth = depthFromTexture(depthMap, uv);

    // Early out if depth is out of range, such as in the sky
    if (depth >= 1.0 || depth <= 0.0) {
      fragOcclusion = 1.0;
      return;
    }

    // get the normal of current fragment
    ivec2 iuv = ivec2(uv * vec2(textureSize(normalMap, 0)));
    vec4 norm4 = texelFetch(normalMap, iuv, 0);
    if(norm4.a != 1.0) {
      fragOcclusion = 1.0;
      return;
    }
    vec3 norm = normalize(norm4.xyz * 2.0 - 1.0);

    float currentPixelDepth = linearizeDepth(depth);
    vec3 currentPixelPos = reconstructPosition(gl_FragCoord.xy, currentPixelDepth);

    float sum = 0.0;
    vec3 tapPixelPos;

    vec3 fres = normalize(2.0 * texture(rnm, uv * rnmScale).xyz - 1.0);

    // note: the factor 2.0 should not be necessary, but makes ssao much nicer.
    // bug or deviation from CE somewhere else?
    float ps = projScale / (2.0 * currentPixelPos.z * zScale.x + zScale.y);

    for(int i = 0; i < ${m.H.int(16)}; ++i) {
      vec2 unitOffset = reflect(sphere[i], fres).xy;
      vec2 offset = vec2(-unitOffset * radius * ps);

      // don't use current or very nearby samples
      if( abs(offset.x) < 2.0 || abs(offset.y) < 2.0){
        continue;
      }

      vec2 tc = vec2(gl_FragCoord.xy + offset);
      if (tc.x < 0.0 || tc.y < 0.0 || tc.x > screenSize.x || tc.y > screenSize.y) continue;
      vec2 tcTap = tc / screenSize;
      float occluderFragmentDepth = linearDepthFromTexture(depthMap, tcTap);

      tapPixelPos = reconstructPosition(tc, occluderFragmentDepth);

      sum += aoValueFromPositionsAndNormal(currentPixelPos, norm, tapPixelPos);
    }

    // output the result
    float A = max(1.0 - sum * intensity / float(${m.H.int(16)}), 0.0);

    // Anti-tone map to reduce contrast and drag dark region farther: (x^0.2 + 1.2 * x^4) / 2.2
    A = (pow(A, 0.2) + 1.2 * pow(A, 4.0)) * INV_GAMMA;

    fragOcclusion = A;
  `),e}function g(e){return Math.max(10,20*e.computeScreenPixelSizeAtDist(Math.abs(4*e.relativeElevation)))}const x=(0,a.vt)(),b=Object.freeze(Object.defineProperty({__proto__:null,build:v,getRadius:g},Symbol.toStringTag,{value:"Module"}));r.d(t,["S",0,b])},26599(e,t,r){r.d(t,{b:()=>u});var o=r(50400),a=r(16937),i=r(37138),n=r(19635),s=r(62462),l=r(29247),c=r(19778),d=r(43398);function u(){const e=new d.N5,t=e.fragment;return e.include(o.c),t.include(a.E),t.uniforms.add(new c.N("depthMap",e=>e.depthTexture),new l.o("tex",e=>e.colorTexture),new i.t("blurSize",e=>e.blurSize),new n.m("projScale",(e,t)=>{const r=t.camera.distance;return r>5e4?Math.max(0,e.projScale-(r-5e4)):e.projScale})),t.code.add(s.H`
    void blurFunction(vec2 uv, float r, float center_d, float sharpness, inout float wTotal, inout float bTotal) {
      float c = texture(tex, uv).r;
      float d = linearDepthFromTexture(depthMap, uv);

      float ddiff = d - center_d;

      float w = exp(-r * r * ${s.H.float(.08)} - ddiff * ddiff * sharpness);
      wTotal += w;
      bTotal += w * c;
    }
  `),e.outputs.add("fragBlur","float"),t.main.add(s.H`
    float b = 0.0;
    float w_total = 0.0;

    float center_d = linearDepthFromTexture(depthMap, uv);

    float sharpness = -0.05 * projScale / center_d;
    for (int r = -${s.H.int(4)}; r <= ${s.H.int(4)}; ++r) {
      float rf = float(r);
      vec2 uvOffset = uv + rf * blurSize;
      blurFunction(uvOffset, rf, center_d, sharpness, w_total, b);
    }
    fragBlur = b / w_total;`),e}const h=Object.freeze(Object.defineProperty({__proto__:null,build:u},Symbol.toStringTag,{value:"Module"}));r.d(t,["S",0,h])},18546(e,t,r){r.d(t,{a:()=>i,f:()=>n,n:()=>a});var o=r(62088);function a(e,t){i(e.typedBuffer,t.typedBuffer,e.typedBufferStride,t.typedBufferStride)}function i(e,t,r=2,a=r){const i=t.length/2;let n=0,s=0;if(!(0,o.iu)(t)||(0,o.dk)(t)){for(let o=0;o<i;++o)e[n]=t[s],e[n+1]=t[s+1],n+=r,s+=a;return}const l=(0,o.a3)(t);if((0,o.JI)(t))for(let o=0;o<i;++o)e[n]=Math.max(t[s]/l,-1),e[n+1]=Math.max(t[s+1]/l,-1),n+=r,s+=a;else for(let o=0;o<i;++o)e[n]=t[s]/l,e[n+1]=t[s+1]/l,n+=r,s+=a}function n(e,t,r,o){const a=e.typedBuffer,i=e.typedBufferStride,n=o?.count??e.count;let s=(o?.dstIndex??0)*i;for(let e=0;e<n;++e)a[s]=t,a[s+1]=r,s+=i}Object.freeze(Object.defineProperty({__proto__:null,fill:n,normalizeIntegerBuffer:i,normalizeIntegerBufferView:a},Symbol.toStringTag,{value:"Module"}))},72449(e,t,r){r.d(t,{a:()=>i,b:()=>s,c:()=>a,d:()=>n,e:()=>h,f:()=>d,l:()=>c,n:()=>m,t:()=>u}),r(6273);var o=r(83851);function a(e,t,r){i(e.typedBuffer,t.typedBuffer,r,e.typedBufferStride,t.typedBufferStride)}function i(e,t,r,a=3,i=a){const n=(0,o.k)(e.length,a,3),s=(0,o.k)(t.length,i,3),l=Math.min(n,s),c=r[0],d=r[1],u=r[2],h=r[4],m=r[5],p=r[6],f=r[8],v=r[9],g=r[10],x=r[12],b=r[13],y=r[14];let w=0,M=0;for(let r=0;r<l;r++){const r=t[w],o=t[w+1],n=t[w+2];e[M]=c*r+h*o+f*n+x,e[M+1]=d*r+m*o+v*n+b,e[M+2]=u*r+p*o+g*n+y,w+=i,M+=a}return e}function n(e,t,r){s(e.typedBuffer,t.typedBuffer,r,e.typedBufferStride,t.typedBufferStride)}function s(e,t,r,a=3,i=a){const n=(0,o.k)(e.length,a,3),s=(0,o.k)(t.length,i,3),l=Math.min(n,s),c=r[0],d=r[1],u=r[2],h=r[3],m=r[4],p=r[5],f=r[6],v=r[7],g=r[8];let x=0,b=0;for(let r=0;r<l;r++){const r=t[x],o=t[x+1],n=t[x+2];e[b]=c*r+h*o+f*n,e[b+1]=d*r+m*o+v*n,e[b+2]=u*r+p*o+g*n,x+=i,b+=a}}function l(e,t,r,o=3,a=o){const i=Math.min(e.length/o,t.length/a);let n=0,s=0;for(let l=0;l<i;l++)e[s]=r*t[n],e[s+1]=r*t[n+1],e[s+2]=r*t[n+2],n+=a,s+=o;return e}function c(e,t,r,o){d(e.typedBuffer,t.typedBuffer,r,o,e.typedBufferStride,t.typedBufferStride)}function d(e,t,r,o,a=3,i=a){const n=Math.min(e.length/a,t.length/i);let s=0,l=0;const c=1/2.2;for(let d=0;d<n;d++)e[l]=o*(r*t[s])**c,e[l+1]=o*(r*t[s+1])**c,e[l+2]=o*(r*t[s+2])**c,s+=i,l+=a}function u(e,t,r,a=3,i=a){const n=(0,o.k)(e.length,a,3),s=(0,o.k)(t.length,i,3),l=Math.min(n,s);let c=0,d=0;for(let o=0;o<l;o++)e[d]=t[c]+r[0],e[d+1]=t[c+1]+r[1],e[d+2]=t[c+2]+r[2],c+=i,d+=a;return e}function h(e,t){m(e.typedBuffer,t.typedBuffer,e.typedBufferStride,t.typedBufferStride)}function m(e,t,r=3,o=r){const a=Math.min(e.length/r,t.length/o);let i=0,n=0;for(let s=0;s<a;s++){const a=t[i],s=t[i+1],l=t[i+2],c=a*a+s*s+l*l;if(c>0){const t=1/Math.sqrt(c);e[n]=t*a,e[n+1]=t*s,e[n+2]=t*l}i+=o,n+=r}}Object.freeze(Object.defineProperty({__proto__:null,linearToSRGB:d,linearToSRGBView:c,normalize:m,normalizeView:h,scale:l,scaleView:function(e,t,r){l(e.typedBuffer,t.typedBuffer,r,e.typedBufferStride,t.typedBufferStride)},shiftRight:function(e,t,r){const o=Math.min(e.count,t.count),a=e.typedBuffer,i=e.typedBufferStride,n=t.typedBuffer,s=t.typedBufferStride;let l=0,c=0;for(let e=0;e<o;e++)a[c]=n[l]>>r,a[c+1]=n[l+1]>>r,a[c+2]=n[l+2]>>r,l+=s,c+=i},transformMat3:s,transformMat3View:n,transformMat4:i,transformMat4View:a,translate:u},Symbol.toStringTag,{value:"Module"}))},19165(e,t,r){function o(){return[0,0,0,1]}function a(e){return[e[0],e[1],e[2],e[3]]}r.d(t,{o8:()=>a,vt:()=>o});const i=[0,0,0,1];Object.freeze(Object.defineProperty({__proto__:null,IDENTITY:i,clone:a,create:o,fromValues:function(e,t,r,o){return[e,t,r,o]}},Symbol.toStringTag,{value:"Module"})),r.d(t,["zK",0,i])},14571(e,t,r){function o(){return new Float32Array(2)}function a(e,t){const r=new Float32Array(2);return r[0]=e,r[1]=t,r}function i(){return o()}function n(){return a(1,1)}function s(){return a(1,0)}function l(){return a(0,1)}r.d(t,{fA:()=>a,vt:()=>o});const c=i(),d=n(),u=s(),h=l();Object.freeze(Object.defineProperty({__proto__:null,ONES:d,UNIT_X:u,UNIT_Y:h,ZEROS:c,clone:function(e){const t=new Float32Array(2);return t[0]=e[0],t[1]=e[1],t},create:o,fromValues:a,ones:n,unitX:s,unitY:l,zeros:i},Symbol.toStringTag,{value:"Module"})),r.d(t,["Un",0,d,"uY",0,c])},64159(e,t,r){r.d(t,{g:()=>n});var o=r(19913),a=r(49093),i=r(88133);function n(e,t,r,o){if((0,a.canProjectWithoutEngine)(e.spatialReference,r))return s[0]=e.x,s[1]=e.y,s[2]=e.z??0,(0,i.projectBuffer)(s,e.spatialReference,0,t,r,0);const n=(0,a.tryProject)(e,r,o);return!!n&&(t[0]=n.x,t[1]=n.y,t[2]=n.z??0,!0)}const s=(0,o.vt)()},29492(e,t,r){r.d(t,{F:()=>s});var o=r(49093),a=r(44153),i=r(88133),n=r(64159);function s(e,t,r,a){return!(null==t||null==a||e.length<2)&&((0,o.canProjectWithoutEngine)(t,a)?(0,i.projectBuffer)(e,t,0,r,a,0,1):(l.x=e[0],l.y=e[1],l.z=e[2],l.spatialReference=t,(0,n.g)(l,r,a)))}const l={x:0,y:0,z:0,hasZ:!0,hasM:!1,spatialReference:a.A.WGS84,type:"point"}},83851(e,t,r){function o(e,t,r){if(t<=0)return 0;const o=e-r;return o<0?0:Math.floor(o/t)+1}r.d(t,{k:()=>o}),r(80861)},87368(e,t,r){r.d(t,{$Q:()=>y,C:()=>s,Cr:()=>d,O_:()=>c,Qj:()=>l,T7:()=>x,Tj:()=>b,lU:()=>u,mN:()=>w,vE:()=>M,vt:()=>n});var o=r(4506),a=r(71573),i=r(19913);function n(e=S){return[e[0],e[1],e[2],e[3]]}function s(e,t){return function(e,t,r,o,a=n()){return a[0]=e,a[1]=t,a[2]=r,a[3]=o,a}(t[0],t[1],t[2],t[3],e)}function l(e){return e}function c(e,t,r){const o=t[0]*t[0]+t[1]*t[1]+t[2]*t[2],a=Math.abs(o-1)>1e-5&&o>1e-12?1/Math.sqrt(o):1;return r[0]=t[0]*a,r[1]=t[1]*a,r[2]=t[2]*a,r[3]=-(r[0]*e[0]+r[1]*e[1]+r[2]*e[2]),r}function d(e,t,r,o=n()){const a=r[0]-t[0],i=r[1]-t[1],s=r[2]-t[2],l=e[0]-t[0],c=e[1]-t[1],d=e[2]-t[2],u=i*d-s*c,h=s*l-a*d,m=a*c-i*l,p=u*u+h*h+m*m,f=Math.abs(p-1)>1e-5&&p>1e-12?1/Math.sqrt(p):1;return o[0]=u*f,o[1]=h*f,o[2]=m*f,o[3]=-(o[0]*e[0]+o[1]*e[1]+o[2]*e[2]),o}function u(e,t,r,o=0,i=Math.floor(r*(1/3)),n=Math.floor(r*(2/3))){if(r<3)return!1;t(m,o);let s=i,l=!1;for(;s<r-1&&!l;)t(p,s),s++,l=!(0,a.t2)(m,p);if(!l)return!1;for(s=Math.max(s,n),l=!1;s<r&&!l;)t(f,s),s++,(0,a.Re)(v,m,p),(0,a.S8)(v,v),(0,a.Re)(g,p,f),(0,a.S8)(g,g),l=!(0,a.t2)(m,f)&&!(0,a.t2)(p,f)&&Math.abs((0,a.Om)(v,g))<h;return l?(d(m,p,f,e),!0):(0!==o||1!==i||2!==n)&&u(e,t,r,0,1,2)}r(71072),r(74695),r(11631),r(45773);const h=.99619469809,m=(0,i.vt)(),p=(0,i.vt)(),f=(0,i.vt)(),v=(0,i.vt)(),g=(0,i.vt)();function x(e,t,r){return function(e){return 0===e||1===e}(M(e,t.origin,t.vector,0,r))}function b(e,t){return w(e,t)>=0}function y(e,t){const r=(0,a.Om)(e,t.ray.direction),o=-w(e,t.ray.origin);if(o<0&&r>=0)return!1;if(r>-1e-6&&r<1e-6)return o>0;if((o<0||r<0)&&!(o<0&&r<0))return!0;const i=o/r;return r>0?i<t.c1&&(t.c1=i):i>t.c0&&(t.c0=i),t.c0<=t.c1}function w(e,t){return(0,a.Om)(e,t)+e[3]}function M(e,t,r,i,n){const s=(0,a.Om)(e,r),l=w(e,t);if(0===s)return l>=0?2:3;let c=-l/s;return 1&i&&(c=(0,o.qE)(c,0,1)),!(4&i)&&c<0||!(8&i)&&c>1?l>=0?2:3:((0,a.WQ)(n,t,(0,a.hs)(n,r,c)),l>=0?0:1)}const S=[0,0,1,0]},74695(e,t,r){r.d(t,{g7:()=>s,gr:()=>n});var o=r(4506),a=r(71573),i=r(19913);function n(e,t){return(0,a.Om)(e,t)/(0,a.Bw)(e)}function s(e,t){const r=(0,a.Om)(e,t)/((0,a.Bw)(e)*(0,a.Bw)(t));return-(0,o.XM)(r)}(0,i.vt)(),(0,i.vt)()},11631(e,t,r){r.d(t,{Rc:()=>m,J8:()=>p,rq:()=>u,Km:()=>h}),r(6273);var o=r(71709),a=r(79441),i=r(26110),n=r(19165),s=r(56560),l=r(19913),c=r(76982);class d{constructor(e){this._create=e,this._items=new Array,this._itemsPtr=0}get(){return 0===this._itemsPtr&&(0,o.d)(()=>this._reset()),this._itemsPtr>=this._items.length&&this._items.push(this._create()),this._items[this._itemsPtr++]}_reset(){const e=2*this._itemsPtr;this._items.length>e&&(this._items.length=e),this._itemsPtr=0}static createVec2f64(){return new d(s.vt)}static createVec3f64(){return new d(l.vt)}static createVec4f64(){return new d(c.vt)}static createMat3f64(){return new d(a.vt)}static createMat4f64(){return new d(i.vt)}static createQuatf64(){return new d(n.vt)}get test(){}}d.createVec2f64();const u=d.createVec3f64(),h=d.createVec4f64(),m=(d.createMat3f64(),d.createMat4f64()),p=d.createQuatf64()},40102(e,t,r){r.d(t,{i:()=>a});var o=r(92840);function a(e,t){return new Promise((r,a)=>{e.readyState>=HTMLMediaElement.HAVE_CURRENT_DATA?r():(t((0,o.Oo)(e,"canplay",r)),t((0,o.Oo)(e,"error",a)))})}},22380(e,t,r){r.d(t,{R:()=>l});var o=r(85575),a=r(3132),i=r(62991),n=r(37623),s=r(19759);class l{constructor(e=e=>e){this._resolveURI=e}async loadJSON(e,t){return this._load("json",e,t)}async loadBinary(e,t){return(0,s.DB)(e)?((0,n.Te)(t),(0,s.lJ)(e)):this._load("array-buffer",e,t)}async loadImage(e,t){return this._load("image",e,t)}async _load(e,t,r){t=this._resolveURI(t);const s=await(0,a.Ke)((0,o.A)(t,{responseType:e,...r}));if(s.ok)return s.value.data;throw(0,n.QP)(s.error),new i.A("gltf-loader-request-error",`Request for resource failed: ${s.error}`)}}},82021(e,t,r){r.d(t,{x:()=>n});var o=r(62088),a=r(51831),i=r(68716);function n(e,t){switch(t){case i.WR.TRIANGLES:return function(e){return"number"==typeof e?(0,a.tM)(e):(0,o.mg)(e)?new Uint16Array(e):e}(e);case i.WR.TRIANGLE_STRIP:return function(e){const t="number"==typeof e?e:e.length;if(t<3)return[];const r=t-2,o=(0,a.my)(3*r);if("number"==typeof e){let e=0;for(let t=0;t<r;t+=1)t%2==0?(o[e++]=t,o[e++]=t+1,o[e++]=t+2):(o[e++]=t+1,o[e++]=t,o[e++]=t+2)}else{let t=0;for(let a=0;a<r;a+=1)a%2==0?(o[t++]=e[a],o[t++]=e[a+1],o[t++]=e[a+2]):(o[t++]=e[a+1],o[t++]=e[a],o[t++]=e[a+2])}return o}(e);case i.WR.TRIANGLE_FAN:return function(e){const t="number"==typeof e?e:e.length;if(t<3)return new Uint16Array(0);const r=t-2,o=r<=65536?new Uint16Array(3*r):new Uint32Array(3*r);if("number"==typeof e){let e=0;for(let t=0;t<r;++t)o[e++]=0,o[e++]=t+1,o[e++]=t+2;return o}const a=e[0];let i=e[1],n=0;for(let t=0;t<r;++t){const r=e[t+2];o[n++]=a,o[n++]=i,o[n++]=r,i=r}return o}(e)}}},17079(e,t,r){r.d(t,{KB:()=>n,Xi:()=>a,pn:()=>s,x3:()=>i});var o=r(6273);class a{constructor(e){this.data=e,this.type="encoded-mesh-texture",this.encoding="image/ktx2"}}function i(e){return"encoded-mesh-texture"===e?.type}async function n(e){const t=new Blob([e]),r=await t.text();return JSON.parse(r)}async function s(e,t){if("image/ktx2"===t)return new a(e);const r=new Blob([e],{type:t});let i=URL.createObjectURL(r);switch(t){case"image/jpeg":i+="#.jpg";break;case"image/png":i+="#.png"}const n=new Image;if((0,o.A)("esri-iPhone"))return new Promise((e,t)=>{const r=()=>{a(),e(n)},o=e=>{a(),t(e)},a=()=>{URL.revokeObjectURL(i),n.removeEventListener("load",r),n.removeEventListener("error",o)};n.addEventListener("load",r),n.addEventListener("error",o),n.src=i});try{n.src=i,await n.decode()}catch{}return URL.revokeObjectURL(i),n}},37124(e,t,r){r.d(t,{fetch:()=>St});var o=r(36137),a=r(85012),i=r(4506),n=r(82541),s=r(79441),l=r(25336),c=r(26110),d=r(56560),u=r(71573),h=r(19913),m=r(46373);function p(e,t=!1){return e<=1024?t?new Array(e).fill(0):new Array(e):new Float32Array(e)}var f=r(40041),v=r(72449),g=r(17460),x=r(18546),b=r(22380),y=r(82021),w=r(17079),M=r(14571);function S(e){if(null==e)return null;const t=null!=e.offset?e.offset:M.uY,r=null!=e.rotation?e.rotation:0,o=null!=e.scale?e.scale:M.Un,a=(0,s.fA)(1,0,0,0,1,0,t[0],t[1],1),i=(0,s.fA)(Math.cos(r),-Math.sin(r),0,Math.sin(r),Math.cos(r),0,0,0,1),l=(0,s.fA)(o[0],0,0,0,o[1],0,0,0,1),c=(0,s.vt)();return(0,n.lw)(c,i,l),(0,n.lw)(c,a,c),c}class T{constructor(){this.geometries=new Array,this.materials=new Array,this.textures=new Array}}class C{constructor(e,t,r){this.name=e,this.lodThreshold=t,this.pivotOffset=r,this.stageResources=new T,this.numberOfVertices=0}}var I=r(85575),_=r(3132),P=r(62991),z=r(80861),D=r(28208);class F{constructor(){this._outer=new Map}clear(){this._outer.clear()}get empty(){return 0===this._outer.size}get outerSize(){return this._outer.size}get size(){let e=0;for(const t of this._outer.values())e+=t.size;return e}get(e,t){return this._outer.get(e)?.get(t)}getInner(e){return this._outer.get(e)}set(e,t,r){const o=this._outer.get(e);o?o.set(t,r):this._outer.set(e,new Map([[t,r]]))}delete(e,t){const r=this._outer.get(e);r&&(r.delete(t),0===r.size&&this._outer.delete(e))}pop(e,t){const r=this.get(e,t);return this.delete(e,t),r}*outerMap(){for(const e of this._outer)yield e}*values(){for(const e of this._outer.values())yield*e.values()}*[Symbol.iterator](){for(const[e,t]of this._outer)for(const[r,o]of t)yield[e,r,o]}forEach(e){this._outer.forEach((t,r)=>e(t,r))}forAll(e){this._outer.forEach((t,r)=>t.forEach((t,o)=>e(t,r,o)))}copy(){const e=new F;return this.forAll((t,r,o)=>e.set(r,o,t)),e}}var R=r(37623),O=r(27805),j=r(51831),B=r(67350),H=r(10941),W=r(58170),E=r(96882),N=r(77788),G=r(57725),L=r(76687),V=r(13439);class A extends L.A{constructor(e){super(e),this._numLoading=0,this._disposed=!1,this._textures=e.textures,this.updateTexture(e.textureId),this._acquire(e.normalTextureId,e=>this._textureNormal=e),this._acquire(e.emissiveTextureId,e=>this._textureEmissive=e),this._acquire(e.occlusionTextureId,e=>this._textureOcclusion=e),this._acquire(e.metallicRoughnessTextureId,e=>this._textureMetallicRoughness=e)}dispose(){super.dispose(),this._texture=(0,G.Gz)(this._texture),this._textureNormal=(0,G.Gz)(this._textureNormal),this._textureEmissive=(0,G.Gz)(this._textureEmissive),this._textureOcclusion=(0,G.Gz)(this._textureOcclusion),this._textureMetallicRoughness=(0,G.Gz)(this._textureMetallicRoughness),this._disposed=!0}ensureResources(e){return 0===this._numLoading?2:1}get textureBindParameters(){return new k(this._texture?.texture??null,this._textureNormal?.texture??null,this._textureEmissive?.texture??null,this._textureOcclusion?.texture??null,this._textureMetallicRoughness?.texture??null)}updateTexture(e){null!=this._texture&&e===this._texture.id||(this._texture=(0,G.Gz)(this._texture),this._acquire(e,e=>this._texture=e))}_acquire(e,t){if(null==e)return void t(null);const r=this._textures.acquire(e);if((0,R.$X)(r))return++this._numLoading,void r.then(e=>{if(this._disposed)return(0,G.Gz)(e),void t(null);t(e)}).finally(()=>--this._numLoading);t(r)}}class U extends V.Y{constructor(e=null){super(),this.textureEmissive=e}}class k extends U{constructor(e,t,r,o,a,i,n){super(r),this.texture=e,this.textureNormal=t,this.textureOcclusion=o,this.textureMetallicRoughness=a,this.scale=i,this.normalTextureTransformMatrix=n}}var $=r(31272),q=r(26421);class Z{constructor(e=0,t=!1,r=!0){this.tolerance=e,this.isVerticalRay=t,this.normalRequired=r}}const Y=(0,m.vt)();function J(e,t,r,o,a,i){if(!e.visible)return;const n=(0,u.jb)(ce,o,r),{tolerance:s}=t,l=new Z(s,!1,t.options.normalRequired);if(e.boundingInfo)(0,q.vA)(0===e.type),X(e.boundingInfo,r,n,s,a,l,i);else{const t=e.positionAttribute,o=e.primitivePositionIndices;!function(e,t,r,o,a,i,n,s,l,c){const d=t,h=de,m=Math.abs(d[0]),p=Math.abs(d[1]),f=Math.abs(d[2]),v=m>=p?m>=f?0:2:p>=f?1:2,g=v,x=d[g]<0?2:1,b=(v+x)%3,y=(v+(3-x))%3,w=d[b]/d[g],M=d[y]/d[g],S=1/d[g],T=ee,C=te,I=re,{normalRequired:_}=l;for(let t=r;t<o;++t){const r=3*t,o=n*a[r];(0,u.hZ)(h[0],i[o+0],i[o+1],i[o+2]);const l=n*a[r+1];(0,u.hZ)(h[1],i[l+0],i[l+1],i[l+2]);const d=n*a[r+2];(0,u.hZ)(h[2],i[d+0],i[d+1],i[d+2]),s&&((0,u.C)(h[0],s.applyToVertex(h[0][0],h[0][1],h[0][2],t)),(0,u.C)(h[1],s.applyToVertex(h[1][0],h[1][1],h[1][2],t)),(0,u.C)(h[2],s.applyToVertex(h[2][0],h[2][1],h[2][2],t))),(0,u.jb)(T,h[0],e),(0,u.jb)(C,h[1],e),(0,u.jb)(I,h[2],e);const m=T[b]-w*T[g],p=T[y]-M*T[g],f=C[b]-w*C[g],v=C[y]-M*C[g],x=I[b]-w*I[g],P=I[y]-M*I[g],z=x*v-P*f,D=m*P-p*x,F=f*p-v*m;if((z<0||D<0||F<0)&&(z>0||D>0||F>0))continue;const R=z+D+F;if(0===R)continue;const O=z*(S*T[g])+D*(S*C[g])+F*(S*I[g]);if(O*Math.sign(R)<0)continue;const j=O/R;j>=0&&c(j,j,_?ae(h):null,t)}}(r,n,0,o.length/3,o,t.data,t.stride,a,l,i)}}const K=(0,h.vt)();function X(e,t,r,o,a,i,n){if(null==e)return;const s=function(e,t){return(0,u.hZ)(t,1/e[0],1/e[1],1/e[2])}(r,K);if((0,m.Ne)(Y,e.bbMin),(0,m.vI)(Y,e.bbMax),null!=a&&a.applyToAabb(Y),function(e,t,r,o){return function(e,t,r,o){const a=(e[0]-o-t[0])*r[0],i=(e[3]+o-t[0])*r[0];let n=Math.min(a,i),s=Math.max(a,i);const l=(e[1]-o-t[1])*r[1],c=(e[4]+o-t[1])*r[1];if(s=Math.min(s,Math.max(l,c)),s<0)return!1;if(n=Math.max(n,Math.min(l,c)),n>s)return!1;const d=(e[2]-o-t[2])*r[2],u=(e[5]+o-t[2])*r[2];return s=Math.min(s,Math.max(d,u)),!(s<0)&&(n=Math.max(n,Math.min(d,u)),!(n>s)&&n<1/0)}(e,t,r,o)}(Y,t,s,o)){const{primitiveIndices:s,position:l}=e,c=s?s.length:l.indices.length/3;if(c>se){const s=e.getChildren();if(void 0!==s){for(const e of s)X(e,t,r,o,a,i,n);return}}!function(e,t,r,o,a,i,n,s,l,c,d){const u=e[0],h=e[1],m=e[2],p=t[0],f=t[1],v=t[2],{normalRequired:g}=c;for(let e=0;e<o;++e){const t=s[e],r=3*t,o=n*a[r];let c=i[o],x=i[o+1],b=i[o+2];const y=n*a[r+1];let w=i[y],M=i[y+1],S=i[y+2];const T=n*a[r+2];let C=i[T],I=i[T+1],_=i[T+2];null!=l&&([c,x,b]=l.applyToVertex(c,x,b,e),[w,M,S]=l.applyToVertex(w,M,S,e),[C,I,_]=l.applyToVertex(C,I,_,e));const P=w-c,z=M-x,D=S-b,F=C-c,R=I-x,O=_-b,j=f*O-R*v,B=v*F-O*p,H=p*R-F*f,W=P*j+z*B+D*H,E=W*W;if(E<=le)continue;const N=u-c,G=h-x,L=m-b,V=(N*j+G*B+L*H)*W;if(V<0||V>E)continue;const A=G*D-z*L,U=L*P-D*N,k=N*z-P*G,$=(p*A+f*U+v*k)*W;if($<0||V+$>E)continue;const q=(F*A+R*U+O*k)/W;q>=0&&d(q,q,g?oe(P,z,D,F,R,O,Q):null,t)}}(t,r,0,c,l.indices,l.data,l.stride,s,a,i,n)}}const Q=(0,h.vt)();const ee=(0,h.vt)(),te=(0,h.vt)(),re=(0,h.vt)();function oe(e,t,r,o,a,i,n){return(0,u.hZ)(ie,e,t,r),(0,u.hZ)(ne,o,a,i),(0,u.$A)(n,ie,ne),(0,u.S8)(n,n),n}function ae(e){return(0,u.jb)(ie,e[1],e[0]),(0,u.jb)(ne,e[2],e[0]),(0,u.$A)(Q,ie,ne),(0,u.S8)(Q,Q),Q}const ie=(0,h.vt)(),ne=(0,h.vt)(),se=1e3,le=1e-7*1e-7,ce=(0,h.vt)(),de=[(0,h.vt)(),(0,h.vt)(),(0,h.vt)()];var ue=r(72559),he=r(29290);class me{constructor(e){this.layout=e}elementCount(e){return e.get("position").indices.length}write(e,t,r,o,a){null!=a&&(0,he.vJ)(r,o,this.layout,e,t,a)}}var pe=r(28849),fe=r(42771);function ve(e,t,r,o){ge.output=t.transparent?1:0,ge.polygonOffset=t.polygonOffset,ge.enableOITOffset=t.enableOITOffset;const a=(0,pe.s)(ge);if(!a)return e;const i=be*a.units,n=(0,u.S8)(ye,(0,u.jb)(ye,o,r));return(t,r,o,s)=>{const l=(o?1-Math.abs((0,u.Om)(n,o)):0)*a.factor*xe+i;return e(t,r+l,o,s)}}const ge=new fe.L,xe=2e-5,be=2e-6,ye=(0,h.vt)();var we=r(73395),Me=r(31635),Se=r(69636),Te=r(76982),Ce=r(29386),Ie=r(7724),_e=r(83143),Pe=r(70051),ze=r(73218),De=r(84618),Fe=r(8445),Re=r(28116);r(3223),r(4012);var Oe=r(73783),je=r(57888),Be=r(45773);class He{constructor(e){this.localTransform=e.localTransform,this.globalTransform=e.globalTransform,this.modelOrigin=e.modelOrigin,this.model=e.instanceModel,this.modelNormal=e.instanceModelNormal,this.modelScaleFactors=e.modelScaleFactors,this.boundingSphere=e.boundingSphere,this.featureAttribute=e.getField("instanceFeatureAttribute",f.Eq),this.color=e.getField("instanceColor",f.XP),this.olidColor=e.getField("instanceOlidColor",f.XP),this.state=e.getField("state",f.SL),this.lodLevel=e.getField("lodLevel",f.SL)}}let We=class extends Oe.A{constructor(e,t){super(e),this.events=new je.bk,this._capacity=0,this._size=0,this._next=0,this._highlightOptionsMap=new Map,this._highlightOptionsMapPrev=new Map,this._layout=function(e){return Ne(Ee.clone(),e).u8("state").u8("lodLevel")}(t),this._capacity=Ue,this._buffer=this._layout.createBuffer(this._capacity),this._view=new He(this._buffer)}get capacity(){return this._capacity}get size(){return this._size}get view(){return this._view}addInstance(){this._size+1>this._capacity&&this._grow();const e=this._findSlot();return this._view.state.set(e,1),this._size++,this.events.emit("instances-changed"),e}removeInstance(e){const t=this._view.state;(0,q.vA)(e>=0&&e<this._capacity&&!!(1&t.get(e)),"invalid instance handle"),this._getStateFlag(e,18)?this._setStateFlags(e,32):this.freeInstance(e),this.events.emit("instances-changed")}freeInstance(e){const t=this._view.state;(0,q.vA)(e>=0&&e<this._capacity&&!!(1&t.get(e)),"invalid instance handle"),t.set(e,0),this._size--}setLocalTransform(e,t,r=!0){this._view.localTransform.setMat(e,t),r&&this.updateModelTransform(e)}getLocalTransform(e,t){this._view.localTransform.getMat(e,t)}setGlobalTransform(e,t,r=!0){this._view.globalTransform.setMat(e,t),r&&this.updateModelTransform(e)}getGlobalTransform(e,t){this._view.globalTransform.getMat(e,t)}updateModelTransform(e){const t=this._view,r=Ge,o=Le;t.localTransform.getMat(e,Ve),t.globalTransform.getMat(e,Ae);const a=(0,l.lw)(Ae,Ae,Ve);(0,u.hZ)(r,a[12],a[13],a[14]),t.modelOrigin.setVec(e,r),(0,n.z0)(o,a),t.model.setMat(e,o);const i=(0,Be.wp)(Ge,a);i.sort(),t.modelScaleFactors.set(e,0,i[1]),t.modelScaleFactors.set(e,1,i[2]),(0,n.B8)(o,o),(0,n.mg)(o,o),t.modelNormal.setMat(e,o),this._setStateFlags(e,64),this.events.emit("instance-transform-changed",{index:e})}getModelTransform(e,t){const r=this._view;r.model.getMat(e,Le),r.modelOrigin.getVec(e,Ge),t[0]=Le[0],t[1]=Le[1],t[2]=Le[2],t[3]=0,t[4]=Le[3],t[5]=Le[4],t[6]=Le[5],t[7]=0,t[8]=Le[6],t[9]=Le[7],t[10]=Le[8],t[11]=0,t[12]=Ge[0],t[13]=Ge[1],t[14]=Ge[2],t[15]=1}applyShaderTransformation(e,t){null!=this.shaderTransformation&&this.shaderTransformation.applyTransform(this,e,t)}getCombinedModelTransform(e,t){return this.getModelTransform(e,t),null!=this.shaderTransformation&&this.shaderTransformation.applyTransform(this,e,t),t}getCombinedLocalTransform(e,t){this._view.localTransform.getMat(e,t),null!=this.shaderTransformation&&this.shaderTransformation.applyTransform(this,e,t)}getCombinedMaxScaleFactor(e){let t=this._view.modelScaleFactors.get(e,1);return null!=this.shaderTransformation&&(this.shaderTransformation.scaleFactor(Ge,this,e),t*=Math.max(Ge[0],Ge[1],Ge[2])),t}getCombinedMedianScaleFactor(e){let t=this._view.modelScaleFactors.get(e,0);return null!=this.shaderTransformation&&(this.shaderTransformation.scaleFactor(Ge,this,e),t*=function(e,t,r){return Math.max(Math.min(e,t),Math.min(Math.max(e,t),r))}(Ge[0],Ge[1],Ge[2])),t}getModel(e,t){this._view.model.getMat(e,t)}setFeatureAttribute(e,t){this._view.featureAttribute?.setVec(e,t)}getFeatureAttribute(e,t){this._view.featureAttribute?.getVec(e,t)}setColor(e,t){this._view.color?.setVec(e,t)}setObjectAndLayerIdColor(e,t){this._view.olidColor?.setVec(e,t)}setVisible(e,t){t!==this.getVisible(e)&&(this._setStateFlag(e,4,t),this.events.emit("instance-visibility-changed",{index:e}))}getVisible(e){return this._getStateFlag(e,4)}setHighlight(e,t){const{_highlightOptionsMap:r}=this,o=r.get(e);t?t!==o&&(r.set(e,t),this._setStateFlag(e,8,!0),this.events.emit("instance-highlight-changed")):o&&(r.delete(e),this._setStateFlag(e,8,!1),this.events.emit("instance-highlight-changed"))}get highlightOptionsMap(){return this._highlightOptionsMap}getHighlightStateFlag(e){return this._getStateFlag(e,8)}geHighlightOptionsPrev(e){const t=this._highlightOptionsMapPrev.get(e)??null;return this._highlightOptionsMapPrev.delete(e),t}getHighlightName(e){const t=this.highlightOptionsMap.get(e)??null;return t?this._highlightOptionsMapPrev.set(e,t):this._highlightOptionsMapPrev.delete(e),t}getState(e){return this._view.state.get(e)}getLodLevel(e){return this._view.lodLevel.get(e)}countFlags(e){let t=0;for(let r=0;r<this._capacity;++r)this.getState(r)&e&&++t;return t}_setStateFlags(e,t){const r=this._view.state;t=r.get(e)|t,r.set(e,t)}_clearStateFlags(e,t){const r=this._view.state;t=r.get(e)&~t,r.set(e,t)}_setStateFlag(e,t,r){r?this._setStateFlags(e,t):this._clearStateFlags(e,t)}_getStateFlag(e,t){return!!(this._view.state.get(e)&t)}_grow(){this._capacity=Math.max(Ue,Math.floor(1.5*this._capacity)),this._buffer=this._layout.createBuffer(this._capacity).copyFrom(this._buffer),this._view=new He(this._buffer)}_findSlot(){const e=this._view.state;let t=this._next;for(;1&e.get(t);)t=t+1===this._capacity?0:t+1;return this._next=t+1===this._capacity?0:t+1,t}};(0,Me.Cg)([(0,Se.MZ)({constructOnly:!0})],We.prototype,"shaderTransformation",void 0),(0,Me.Cg)([(0,Se.MZ)()],We.prototype,"_size",void 0),(0,Me.Cg)([(0,Se.MZ)({readOnly:!0})],We.prototype,"size",null),We=(0,Me.Cg)([(0,Se.$K)("esri.views.3d.webgl-engine.lib.lodRendering.InstanceData")],We);const Ee=(0,Ie.BP)().mat4f64("localTransform").mat4f64("globalTransform").vec4f64("boundingSphere").vec3f64("modelOrigin").mat3f("instanceModel").mat3f("instanceModelNormal").vec2f("modelScaleFactors");function Ne(e,t){return t.instancedFeatureAttribute&&e.vec4f("instanceFeatureAttribute"),t.instancedColor&&e.vec4u8("instanceColor"),(0,De.E)()&&e.vec4u8("instanceOlidColor"),e}const Ge=(0,h.vt)(),Le=(0,s.vt)(),Ve=(0,c.vt)(),Ae=(0,c.vt)(),Ue=64,ke=(0,Ie.BP)().vec3f("instanceModelOriginHi").vec3f("instanceModelOriginLo").mat3f("instanceModel").mat3f("instanceModelNormal");var $e=r(40327),qe=r(12668),Ze=r(15651),Ye=r(76221);class Je extends _e.Zo{constructor(){super(...arguments),this.isSchematic=!1,this.usePBR=!1,this.mrrFactors=$e.mb,this.hasVertexColors=!1,this.hasSymbolColors=!1,this.doubleSided=!1,this.doubleSidedType="normal",this.cullFace=2,this.instanced=!1,this.instancedFeatureAttribute=!1,this.instancedColor=!1,this.instanceColorEncodesAlphaIgnore=!1,this.emissiveStrengthFromSymbol=0,this.emissiveStrengthKHR=1,this.emissiveSource=1,this.emissiveBaseColor=h.uY,this.instancedDoublePrecision=!1,this.normalType=0,this.receiveShadows=!0,this.receiveAmbientOcclusion=!0,this.castShadows=!0,this.ambient=(0,h.CN)(.2,.2,.2),this.diffuse=(0,h.CN)(.8,.8,.8),this.externalColor=(0,Te.fA)(1,1,1,1),this.colorMixMode="multiply",this.opacity=1,this.layerOpacity=1,this.origin=(0,h.vt)(),this.hasSlicePlane=!1,this.offsetTransparentBackfaces=!1,this.vvSize=null,this.vvColor=null,this.vvOpacity=null,this.modelTransformation=null,this.drivenOpacity=!1,this.writeDepth=!0,this.customDepthTest=0,this.textureAlphaMode=0,this.textureAlphaCutoff=Ye.Q,this.textureAlphaPremultiplied=!1,this.renderOccluded=1,this.testsTransparentRenderOrder=0,this.isDecoration=!1}get hasVVSize(){return!!this.vvSize}get hasVVColor(){return!!this.vvColor}get hasVVOpacity(){return!!this.vvOpacity}}_e.gy;let Ke=class extends ze.w{constructor(e,t){let o=(0,Ce.U)(et(t));t.instanced&&t.instancedDoublePrecision&&(o=o.concat((0,Ce.U)(function(e){return Ne(ke.clone(),e)}(t)))),super(e,t,o),this.shader=new Pe.r(qe.D,()=>r.e(1084).then(r.bind(r,41084))),this.ignoreUnused=!0}_makePipeline(e,t){const{output:r,transparent:o,cullFace:a,customDepthTest:i,hasOccludees:n}=e;return(0,Ze.Ey)({blending:o?(0,Fe.Yf)(r,!1,e.emissionDimmingPass):null,culling:Qe(e)?(0,Ze.Xt)(a):null,depthTest:(0,Fe.mt)(r,Xe(i)),depthWrite:(0,Fe.z5)(e),colorWrite:Ze.kn,stencilWrite:n?Re.v0:null,stencilTest:n?t?Re.Ax:Re.cP:null,polygonOffset:(0,pe.s)(e)})}initializePipeline(e){return this._occludeePipelineState=this._makePipeline(e,!0),this._makePipeline(e,!1)}getPipeline(e,t,r){return r?this._occludeePipelineState:super.getPipeline(e,t,r)}};function Xe(e){switch(e){case 1:return 515;case 0:case 3:return 513;case 2:return 516}}function Qe(e){return 0!==e.cullFace||!e.hasSlicePlane&&!e.transparent&&!e.doubleSidedMode}function et(e){const t=(0,Ie.BP)().vec3f("position");return 1===e.normalType?t.vec2i16("normalCompressed",{glNormalized:!0}):t.vec3f("normal"),e.hasVertexTangents&&t.vec4f("tangent"),e.hasTextures&&t.vec2f16("uv0"),e.hasVertexColors&&t.vec4u8("color",{glNormalized:!0}),e.hasSymbolColors&&t.vec4u8("symbolColor"),!e.instanced&&(0,De.E)()&&t.vec4u8("olidColor"),t}Ke=(0,Me.Cg)([(0,Se.$K)("esri.views.3d.webgl-engine.shaders.DefaultMaterialTechnique")],Ke);var tt=r(67069);class rt extends fe.L{constructor(e){super(),this.spherical=e,this.alphaDiscardMode=1,this.doubleSidedMode=0,this.pbrMode=0,this.cullFace=0,this.normalType=0,this.customDepthTest=0,this.emissionSource=0,this.hasVertexColors=!1,this.hasSymbolColors=!1,this.hasVerticalOffset=!1,this.hasColorTexture=!1,this.hasMetallicRoughnessTexture=!1,this.hasOcclusionTexture=!1,this.hasNormalTexture=!1,this.hasScreenSizePerspective=!1,this.hasVertexTangents=!1,this.hasOccludees=!1,this.instanced=!1,this.instancedDoublePrecision=!1,this.hasModelTransformation=!1,this.offsetBackfaces=!1,this.hasVVSize=!1,this.hasVVColor=!1,this.receiveShadows=!1,this.hasShadowHighlights=!1,this.receiveAmbientOcclusion=!1,this.receiveGlobalIllumination=!1,this.textureAlphaPremultiplied=!1,this.instancedFeatureAttribute=!1,this.instancedColor=!1,this.writeDepth=!0,this.snowCover=!1,this.hasColorTextureTransform=!1,this.hasEmissionTextureTransform=!1,this.hasNormalTextureTransform=!1,this.hasOcclusionTextureTransform=!1,this.hasMetallicRoughnessTextureTransform=!1,this.useCustomDTRExponentForWater=!1,this.useFillLights=!0,this.draped=!1}get textureCoordinateType(){return this.hasTextures?1:0}get hasTextures(){return this.hasColorTexture||this.hasNormalTexture||this.hasMetallicRoughnessTexture||3===this.emissionSource||this.hasOcclusionTexture}get hasVVInstancing(){return this.instanced}get discardInvisibleFragments(){return this.transparent}}(0,Me.Cg)([(0,tt.W)({count:4})],rt.prototype,"alphaDiscardMode",void 0),(0,Me.Cg)([(0,tt.W)({count:3})],rt.prototype,"doubleSidedMode",void 0),(0,Me.Cg)([(0,tt.W)({count:7})],rt.prototype,"pbrMode",void 0),(0,Me.Cg)([(0,tt.W)({count:3})],rt.prototype,"cullFace",void 0),(0,Me.Cg)([(0,tt.W)({count:3})],rt.prototype,"normalType",void 0),(0,Me.Cg)([(0,tt.W)({count:3})],rt.prototype,"customDepthTest",void 0),(0,Me.Cg)([(0,tt.W)({count:8})],rt.prototype,"emissionSource",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasVertexColors",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasSymbolColors",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasVerticalOffset",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasColorTexture",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasMetallicRoughnessTexture",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasOcclusionTexture",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasNormalTexture",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasScreenSizePerspective",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasVertexTangents",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasOccludees",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"instanced",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"instancedDoublePrecision",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasModelTransformation",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"offsetBackfaces",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasVVSize",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasVVColor",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"receiveShadows",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasShadowHighlights",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"receiveAmbientOcclusion",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"receiveGlobalIllumination",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"textureAlphaPremultiplied",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"instancedFeatureAttribute",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"instancedColor",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"writeDepth",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"snowCover",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasColorTextureTransform",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasEmissionTextureTransform",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasNormalTextureTransform",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasOcclusionTextureTransform",void 0),(0,Me.Cg)([(0,tt.W)()],rt.prototype,"hasMetallicRoughnessTextureTransform",void 0);var ot=r(38716);let at=class extends Ke{constructor(){super(...arguments),this.shader=new Pe.r(ot.R,()=>r.e(6252).then(r.bind(r,56252)))}};at=(0,Me.Cg)([(0,Se.$K)("esri.views.3d.webgl-engine.shaders.RealisticTreeTechnique")],at);class it extends tt.K{constructor(){super(...arguments),this.receiveShadows=!0}}(0,Me.Cg)([(0,tt.W)()],it.prototype,"receiveShadows",void 0);class nt extends $.i{constructor(e,t){super(e,lt),this.materialType="default",this.supportsEdges=!0,this.intersectDraped=void 0,this.produces=new Map([[2,e=>(0,N.uw)(e)&&!this.transparent],[4,e=>(0,N.uw)(e)&&this.transparent&&this.parameters.writeDepth],[8,e=>(0,N.uw)(e)&&this.transparent&&!this.parameters.writeDepth]]),this._layout=et(this.parameters),this._configuration=new rt(t.spherical)}isVisibleForOutput(e){return 5!==e&&7!==e&&6!==e||this.parameters.castShadows}get visible(){const{layerOpacity:e,colorMixMode:t,opacity:r,externalColor:o}=this.parameters;return e*("replace"===t?1:r)*("ignore"===t||isNaN(o[3])?1:o[3])>=Ye.Q}get _hasEmissiveBase(){return!!this.parameters.emissiveTextureId||!(0,u.t2)(this.parameters.emissiveBaseColor,h.uY)}get emissions(){return this.parameters.emissiveStrength>0&&(0===this.parameters.emissiveSource&&this._hasEmissiveBase||1===this.parameters.emissiveSource)?this.transparent?2:1:0}updateConfiguration(e){super.updateConfiguration(e);const{parameters:t,_configuration:r}=this;r.hasNormalTexture=t.hasNormalTexture,r.hasColorTexture=t.hasColorTexture,r.hasMetallicRoughnessTexture=t.hasMetallicRoughnessTexture,r.hasOcclusionTexture=t.hasOcclusionTexture;const{treeRendering:o,doubleSided:a,doubleSidedType:i}=t;r.hasVertexTangents=!o&&t.hasVertexTangents,r.instanced=t.instanced,r.instancedDoublePrecision=t.instancedDoublePrecision,r.hasVVColor=!!t.vvColor,r.hasVVSize=!!t.vvSize,r.hasVerticalOffset=null!=t.verticalOffset,r.hasScreenSizePerspective=null!=t.screenSizePerspective,r.hasSlicePlane=t.hasSlicePlane,r.alphaDiscardMode=t.textureAlphaMode,r.normalType=o?0:t.normalType,r.transparent=this.transparent,r.enableOITOffset=e.enableOITOffset,r.writeDepth=t.writeDepth,r.customDepthTest=t.customDepthTest??0,r.hasOccludees=e.hasOccludees,r.cullFace=t.hasSlicePlane?0:t.cullFace,r.hasModelTransformation=!o&&null!=t.modelTransformation,r.hasVertexColors=t.hasVertexColors,r.hasSymbolColors=t.hasSymbolColors,r.doubleSidedMode=o?2:a&&"normal"===i?1:a&&"winding-order"===i?2:0,r.instancedFeatureAttribute=t.instancedFeatureAttribute,r.instancedColor=t.instancedColor,(0,N._o)(e.output)?(r.receiveShadows=t.receiveShadows,r.hasShadowHighlights=function(e,t){return e.receiveShadows&&null!=t.shadowHighlight?.getTexture()}(r,e),r.receiveAmbientOcclusion=t.receiveAmbientOcclusion&&null!=e.ssao,r.receiveGlobalIllumination=t.receiveAmbientOcclusion&&e.globalIlluminationEnabled):r.receiveShadows=r.hasShadowHighlights=r.receiveAmbientOcclusion=!1,r.textureAlphaPremultiplied=!!t.textureAlphaPremultiplied,r.pbrMode=t.usePBR?t.isSchematic?2:1:0,r.emissionSource=t.emissionSource,r.offsetBackfaces=!(!this.transparent||!t.offsetTransparentBackfaces),r.snowCover=e.snowCover>0,r.hasColorTextureTransform=!!t.colorTextureTransformMatrix,r.hasNormalTextureTransform=!!t.normalTextureTransformMatrix,r.hasEmissionTextureTransform=!!t.emissiveTextureTransformMatrix,r.hasOcclusionTextureTransform=!!t.occlusionTextureTransformMatrix,r.hasMetallicRoughnessTextureTransform=!!t.metallicRoughnessTextureTransformMatrix}intersect(e,t,r,o,a,i){if(null!=this.parameters.verticalOffset){const e=r.camera;(0,u.hZ)(pt,t[12],t[13],t[14]);let i=null;switch(r.viewingMode){case 1:i=(0,u.S8)(ht,pt);break;case 2:i=(0,u.C)(ht,ut)}const n=(0,u.Re)(ft,pt,e.eye),s=(0,u.Bw)(n),l=(0,u.hs)(n,n,1/s);let c=null;this.parameters.screenSizePerspective&&(c=(0,u.Om)(i,l));const d=(0,we.kE)(e,s,this.parameters.verticalOffset,c??0,this.parameters.screenSizePerspective,null);(0,u.hs)(i,i,d),(0,u.ei)(mt,i,r.transform.inverseRotation),o=(0,u.Re)(ct,o,mt),a=(0,u.Re)(dt,a,mt)}i=ve(i,this._configuration,o,a),J(e,r,o,a,(0,ue.ou)(r.verticalOffset),i)}createGLMaterial(e){return new st(e)}createBufferWriter(){return new me(this._layout)}get transparent(){return function(e){const{drivenOpacity:t,opacity:r,externalColor:o,layerOpacity:a,texture:i,textureId:n,textureAlphaMode:s,colorMixMode:l}=e,c=o[3];return t||r<1&&"replace"!==l||c<1&&"ignore"!==l||a<1||(null!=i||null!=n)&&1!==s&&2!==s&&"replace"!==l}(this.parameters)}}class st extends A{constructor(e){super({...e,...e.material.parameters})}beginSlot(e){this._material.setParameters({receiveShadows:e.shadowMap.enabled});const t=this._material.parameters;this.updateTexture(t.textureId);const r=e.camera.viewInverseTransposeMatrix;return(0,u.hZ)(t.origin,r[3],r[7],r[11]),this._material.setParameters(this.textureBindParameters),this.getTechnique(t.treeRendering?at:Ke,e)}}class lt extends Je{constructor(){super(...arguments),this.treeRendering=!1,this.useIndexing=!1,this.hasVertexTangents=!1}get hasNormalTexture(){return!this.treeRendering&&!!this.normalTextureId}get hasColorTexture(){return!!this.textureId}get hasMetallicRoughnessTexture(){return!this.treeRendering&&!!this.metallicRoughnessTextureId}get hasOcclusionTexture(){return!this.treeRendering&&!!this.occlusionTextureId}get emissiveStrength(){return this.emissiveStrengthFromSymbol*this.emissiveStrengthKHR}get emissionSource(){return null!=this.emissiveTextureId&&0===this.emissiveSource?3:0===this.emissiveSource?2:1}get hasTextures(){return this.hasColorTexture||this.hasNormalTexture||this.hasMetallicRoughnessTexture||3===this.emissionSource||this.hasOcclusionTexture}}const ct=(0,h.vt)(),dt=(0,h.vt)(),ut=(0,h.fA)(0,0,1),ht=(0,h.vt)(),mt=(0,h.vt)(),pt=(0,h.vt)(),ft=(0,h.vt)(),vt=()=>z.A.getLogger("esri.views.3d.layers.graphics.objectResourceUtils");class gt{constructor(e,t,r){this.resource=e,this.textures=t,this.usedMemory=r}}function xt(e){const t=e.params,r=t.topology;let o=!0;switch(t.vertexAttributes||(vt().warn("Geometry must specify vertex attributes"),o=!1),t.topology){case"PerAttributeArray":break;case"Indexed":case null:case void 0:{const e=t.faces;if(e){if(t.vertexAttributes)for(const r in t.vertexAttributes){const t=e[r];t?.values?(null!=t.valueType&&"UInt32"!==t.valueType&&(vt().warn(`Unsupported indexed geometry indices type '${t.valueType}', only UInt32 is currently supported`),o=!1),null!=t.valuesPerElement&&1!==t.valuesPerElement&&(vt().warn(`Unsupported indexed geometry values per element '${t.valuesPerElement}', only 1 is currently supported`),o=!1)):(vt().warn(`Indexed geometry does not specify face indices for '${r}' attribute`),o=!1)}}else vt().warn("Indexed geometries must specify faces"),o=!1;break}default:vt().warn(`Unsupported topology '${r}'`),o=!1}e.params.material||(vt().warn("Geometry requires material"),o=!1);const a=e.params.vertexAttributes;for(const e in a)a[e].values||(vt().warn("Geometries with externally defined attributes are not yet supported"),o=!1);return o}function bt(e){const t=(0,m.Ie)();return e.forEach(e=>{const r=e.boundingInfo;null!=r&&((0,m.iT)(t,r.bbMin),(0,m.iT)(t,r.bbMax))}),t}function yt(e){switch(e){case"mask":return 2;case"maskAndTransparency":return 3;case"none":return 1;default:return 0}}function wt(e){const t=e.params;return{id:1,material:t.material,texture:t.texture,region:t.texture}}const Mt=new O.A(1,2,"wosr");async function St(e,t){const s=function(e){const t=e.match(/(.*\.(gltf|glb))(\?lod=([0-9]+))?$/);return t?{fileType:"gltf",url:t[1],specifiedLodIndex:null!=t[4]?Number(t[4]):null}:{fileType:e.match(/(.*\.(json|json\.gz))$/)?"wosr":"unknown",url:e,specifiedLodIndex:null}}((0,a.EM)(e));if("wosr"===s.fileType){const e=await(t.cache?t.cache.loadWOSR(s.url,t):async function(e,t){const r=await async function(e,t){const r=await(0,_.Ke)((0,I.A)(e,t));if(r.ok)return r.value.data;(0,R.QP)(r.error),function(e){throw new P.A("",`Request for object resource failed: ${e}`)}(r.error)}(e,t),o=await async function(e,t){const r=new Array;for(const o in e){const a=e[o],i=a.images[0].data;if(!i){vt().warn("Externally referenced texture data is not yet supported");continue}const n=a.encoding+";base64,"+i,s="/textureDefinitions/"+o,l="rgba"===a.channels?a.alphaChannelUsage||"transparency":"none",c={noUnpackFlip:!0,wrap:{s:10497,t:10497},preMultiplyAlpha:1!==yt(l)},d=t?.disableTextures?Promise.resolve(null):(0,B.D)(n,t);r.push(d.then(e=>({refId:s,image:e,parameters:c,alphaChannelUsage:l})))}const o=await Promise.all(r),a={};for(const e of o)a[e.refId]=e;return a}(r.textureDefinitions??{},t);let a=0;for(const e in o)if(o.hasOwnProperty(e)){const t=o[e];a+=t?.image?t.image.width*t.image.height*4:0}return new gt(r,o,a+(0,D.Qh)(r))}(s.url,t)),{engineResources:r,referenceBoundingBox:o}=function(e,t){const r=new Array,o=new Array,a=new Array,i=new F,n=e.resource,s=O.A.parse(n.version||"1.0","wosr");Mt.validate(s);const l=n.model.name,c=n.model.geometries,d=n.materialDefinitions??{},u=e.textures;let m=0;const p=new Map;for(let e=0;e<c.length;e++){const n=c[e];if(!xt(n))continue;const s=wt(n),l=n.params.vertexAttributes,f=[],v=e=>{if("PerAttributeArray"===n.params.topology)return null;const t=n.params.faces;for(const r in t)if(r===e)return t[r].values;return null},g=l.position,x=g.values.length/g.valuesPerElement;for(const e in l){const t=l[e],r=t.values,o=v(e)??(0,j.tM)(x);f.push([e,new H.n(r,o,t.valuesPerElement,!0)])}const b=s.texture,y=u&&u[b];if(y&&!p.has(b)){const{image:e,parameters:t}=y,r=new E.h(e,t);o.push(r),p.set(b,r)}const w=p.get(b),M=w?w.id:void 0,S=s.material;let T=i.get(S,b);if(null==T){const e=d[S.slice(S.lastIndexOf("/")+1)].params;1===e.transparency&&(e.transparency=0);const r=y?yt(y.alphaChannelUsage):void 0,o={ambient:(0,h.ci)(e.diffuse),diffuse:(0,h.ci)(e.diffuse),opacity:1-(e.transparency||0),textureAlphaMode:r,textureAlphaCutoff:.33,textureId:M,doubleSided:!0,cullFace:0,colorMixMode:e.externalColorMixMode||"tint",textureAlphaPremultiplied:y?.parameters.preMultiplyAlpha??!1};t?.materialParameters&&Object.assign(o,t.materialParameters),T=new nt(o,t),i.set(S,b,T)}a.push(T);const C=new W.V(T,f);m+=f.find(e=>"position"===e[0])?.[1]?.indices.length??0,r.push(C)}return{engineResources:[{name:l,stageResources:{textures:o,materials:a,geometries:r},pivotOffset:n.model.pivotOffset,numberOfVertices:m,lodThreshold:null}],referenceBoundingBox:bt(r)}}(e,t);return{lods:r,referenceBoundingBox:o,isEsriSymbolResource:!1,isWosr:!0}}let M;if(t.cache)M=await t.cache.loadGLTF(s.url,t,!!t.usePBR,!!t.useEmissive);else{const{loadGLTF:e}=await r.e(4141).then(r.bind(r,44141));M=await e(new b.R,s.url,t,t.usePBR,t.useEmissive)}const{engineResources:T,referenceBoundingBox:z}=function(e,t,r){const a=e.model,s=e.meta,b=a.meta?.ESRI_proxyEllipsoid,M=s.isEsriSymbolResource&&null!=b&&"EsriRealisticTreesStyle"===s.ESRI_webstyle;M&&!e.customMeta.esriTreeRendering&&(e.customMeta.esriTreeRendering=!0,function(e,t){for(let r=0;r<e.model.lods.length;++r){const o=e.model.lods[r];for(const a of o.parts){const o=a.attributes.normal;if(null==o)return;const i=a.attributes.position,n=i.count,s=(0,h.vt)(),d=(0,h.vt)(),m=(0,h.vt)(),p=new Float32Array(4*n),v=new Float32Array(3*n),g=(0,l.B8)((0,c.vt)(),a.transform);let x=0,b=0;for(let l=0;l<n;l++){i.getVec(l,d),o.getVec(l,s),(0,u.Z0)(d,d,a.transform),(0,u.Re)(m,d,t.center),(0,u.Qr)(m,m,t.radius);const n=m[2],c=(0,u.Bw)(m),h=Math.min(.45+.55*c*c,1)**2.2;(0,u.Qr)(m,m,t.radius),null!==g&&(0,u.Z0)(m,m,g),(0,u.S8)(m,m),r+1!==e.model.lods.length&&e.model.lods.length>1&&(0,u.Cc)(m,m,s,n>-1?.2:Math.min(-4*n-3.8,1)),v[x]=m[0],v[x+1]=m[1],v[x+2]=m[2],x+=3,p[b]=h,p[b+1]=h,p[b+2]=h,p[b+3]=1,b+=4}a.attributes.normal=new f.xs(v.buffer),a.attributes.color=new f.Eq(p.buffer)}}}(e,b));const T=!!t.usePBR,I=s.isEsriSymbolResource?{usePBR:T,isSchematic:!1,treeRendering:M,mrrFactors:$e.SY}:{usePBR:T,isSchematic:!1,treeRendering:!1,mrrFactors:$e.mb},_={...t.materialParameters,treeRendering:M},P=new Array,z=new Map,D=new Map,F=a.lods.length,R=(0,m.Ie)();return a.lods.forEach((e,s)=>{const l=!0===t.skipHighLods&&(F>1&&0===s||F>3&&1===s)||!1===t.skipHighLods&&null!=r&&s!==r;if(l&&0!==s)return;const c=new C(e.name,e.lodThreshold,[0,0,0]);e.parts.forEach(e=>{const r=l?new nt({},t):function(e,t,r,a,i,n,s,l,c){const u=e.materials.get(t.material);if(null==u)return null;const{normal:h,color:m,texCoord0:p,tangent:f}=t.attributes,v=t.material+(h?"_normal":"")+(m?"_color":"")+(p?"_texCoord0":"")+(f?"_tangent":""),g=null!=t.attributes.texCoord0,x=null!=t.attributes.normal,b=function(e){switch(e){case"BLEND":return 0;case"MASK":return 2;case"OPAQUE":case null:case void 0:return 1}}(u.alphaMode);if(!n.has(v)){if(g){const t=(t,r=!1,o=!1)=>{if(null!=t&&!s.has(t)){const a=e.textures.get(t);if(a){const e=a.data,i=r&&!(0,w.x3)(e)?l.compressionOptions:void 0;s.set(t,new E.h((0,w.x3)(e)?e.data:e,{...a.parameters,preMultiplyAlpha:!(0,w.x3)(e)&&o,encoding:(0,w.x3)(e)?e.encoding:void 0,compressionOptions:i}))}}},r=1!==b&&!c;t(u.colorTexture,r,1!==b),t(u.normalTexture),t(u.occlusionTexture,!0),t(u.emissiveTexture),t(u.metallicRoughnessTexture,!0)}const r=(0,o.xV)(u.color[0]),h=(0,o.xV)(u.color[1]),m=(0,o.xV)(u.color[2]),p=null!=u.colorTexture&&g?s.get(u.colorTexture):null,f=(0,$e.Jr)(u),y=null!=u.normalTextureTransform?.scale?u.normalTextureTransform?.scale:d.Un;n.set(v,new nt({...a,customDepthTest:1,textureAlphaMode:b,textureAlphaCutoff:u.alphaCutoff,diffuse:[r,h,m],ambient:[r,h,m],opacity:"OPAQUE"===u.alphaMode?1:u.opacity,doubleSided:u.doubleSided,doubleSidedType:"winding-order",cullFace:u.doubleSided?0:2,hasVertexColors:!!t.attributes.color,hasVertexTangents:!!t.attributes.tangent,normalType:x?0:2,castShadows:!0,receiveShadows:u.receiveShadows,receiveAmbientOcclusion:u.receiveAmbientOcclusion,textureId:null!=p?p.id:void 0,colorMixMode:u.colorMixMode,normalTextureId:null!=u.normalTexture&&g?s.get(u.normalTexture).id:void 0,textureAlphaPremultiplied:null!=p&&!!p.parameters.preMultiplyAlpha,occlusionTextureId:null!=u.occlusionTexture&&g?s.get(u.occlusionTexture).id:void 0,emissiveTextureId:null!=u.emissiveTexture&&g?s.get(u.emissiveTexture).id:void 0,metallicRoughnessTextureId:null!=u.metallicRoughnessTexture&&g?s.get(u.metallicRoughnessTexture).id:void 0,emissiveBaseColor:[u.emissiveFactor[0],u.emissiveFactor[1],u.emissiveFactor[2]],emissiveStrengthKHR:null!=u.emissiveStrengthKHR?u.emissiveStrengthKHR:1,emissiveStrengthFromSymbol:null!=i.emissiveStrengthFromSymbol?i.emissiveStrengthFromSymbol:void 0,mrrFactors:f?$e.Bt:[u.metallicFactor,u.roughnessFactor,a.mrrFactors[2]],isSchematic:f,colorTextureTransformMatrix:S(u.colorTextureTransform),normalTextureTransformMatrix:S(u.normalTextureTransform),scale:[y[0],y[1]],occlusionTextureTransformMatrix:S(u.occlusionTextureTransform),emissiveTextureTransformMatrix:S(u.emissiveTextureTransform),metallicRoughnessTextureTransformMatrix:S(u.metallicRoughnessTextureTransform),...i},l))}const y=n.get(v);if(r.stageResources.materials.push(y),g){const e=e=>{null!=e&&r.stageResources.textures.push(s.get(e))};e(u.colorTexture),e(u.normalTexture),e(u.occlusionTexture),e(u.emissiveTexture),e(u.metallicRoughnessTexture)}return y}(a,e,c,I,_,z,D,t,M),{geometry:u,vertexCount:h}=function(e,t){const r=e.attributes.position.count,o=(0,y.x)(e.indices||r,e.primitiveType),a=p(3*r),{typedBuffer:s,typedBufferStride:l}=e.attributes.position;(0,v.a)(a,s,e.transform,3,l);const c=[["position",new H.n(a,o,3,!0)]];if(null!=e.attributes.normal){const t=p(3*r),{typedBuffer:a,typedBufferStride:s}=e.attributes.normal;(0,n.Ge)(Tt,e.transform),(0,v.b)(t,a,Tt,3,s),(0,i.or)(Tt)&&(0,v.n)(t,t),c.push(["normal",new H.n(t,o,3,!0)])}if(null!=e.attributes.tangent){const t=p(4*r),{typedBuffer:a,typedBufferStride:s}=e.attributes.tangent;(0,n.z0)(Tt,e.transform),(0,g.t)(t,a,Tt,4,s),(0,i.or)(Tt)&&(0,v.n)(t,t,4),c.push(["tangent",new H.n(t,o,4,!0)])}if(null!=e.attributes.texCoord0){const t=p(2*r),{typedBuffer:a,typedBufferStride:i}=e.attributes.texCoord0;(0,x.a)(t,a,2,i),c.push(["uv0",new H.n(t,o,2,!0)])}const d=e.attributes.color;if(null!=d){const t=new Uint8Array(4*r);4===d.elementCount?d instanceof f.Eq?(0,g.b)(t,d,1,255):(d instanceof f.XP||d instanceof f.Uz)&&(0,g.b)(t,d,1/255,255):(t.fill(255),d instanceof f.xs?(0,v.f)(t,d.typedBuffer,1,255,4,d.typedBufferStride):(e.attributes.color instanceof f.eI||e.attributes.color instanceof f.nS)&&(0,v.f)(t,d.typedBuffer,1/255,255,4,e.attributes.color.typedBufferStride)),c.push(["color",new H.n(t,o,4,!0)])}return{geometry:new W.V(t,c),vertexCount:r}}(e,r??new nt({},t)),b=u.boundingInfo;null!=b&&0===s&&((0,m.iT)(R,b.bbMin),(0,m.iT)(R,b.bbMax)),null!=r&&(c.stageResources.geometries.push(u),c.numberOfVertices+=h)}),l||P.push(c)}),{engineResources:P,referenceBoundingBox:R}}(M,t,s.specifiedLodIndex);return{lods:T,referenceBoundingBox:z,isEsriSymbolResource:M.meta.isEsriSymbolResource,isWosr:!1}}const Tt=(0,s.vt)()},45773(e,t,r){r.d(t,{YH:()=>s,hG:()=>i,nu:()=>l,wp:()=>n}),r(4506);var o=r(71573),a=r(19913);function i(e){const t=e[0]*e[0]+e[4]*e[4]+e[8]*e[8],r=e[1]*e[1]+e[5]*e[5]+e[9]*e[9],o=e[2]*e[2]+e[6]*e[6]+e[10]*e[10];return Math.sqrt(Math.max(t,r,o))}function n(e,t){const r=Math.sqrt(t[0]*t[0]+t[4]*t[4]+t[8]*t[8]),a=Math.sqrt(t[1]*t[1]+t[5]*t[5]+t[9]*t[9]),i=Math.sqrt(t[2]*t[2]+t[6]*t[6]+t[10]*t[10]);return(0,o.hZ)(e,r,a,i),e}function s(e,t,r){r=r||e;const a=(0,o.Om)(e,t);(0,o.hZ)(r,e[0]-a*t[0],e[1]-a*t[1],e[2]-a*t[2]),(0,o.S8)(r,r)}function l(e,t,r,i=(0,a.vt)()){const n=(0,o.Bw)(e),s=(0,o.Bw)(t),l=(0,o.Om)(e,t)/(n*s);if(l<.9999999999999999){const a=Math.acos(l),u=((1-r)*n+r*s)/Math.sin(a),h=u/n*Math.sin((1-r)*a),m=u/s*Math.sin(r*a);return(0,o.hs)(c,e,h),(0,o.hs)(d,t,m),(0,o.WQ)(i,c,d)}return(0,o.Cc)(i,e,t,r)}(0,a.vt)(),(0,a.vt)(),(0,a.vt)();const c=(0,a.vt)(),d=(0,a.vt)()},47635(e,t,r){r.d(t,{o:()=>a});var o=r(62462);function a(e,t){t&&e.varyings.add("linearDepth","float",{invariant:!0}),e.vertex.code.add(o.H`
    void forwardLinearDepth(float _linearDepth) { ${(0,o.If)(t,"linearDepth = _linearDepth;")} }
  `)}},14225(e,t,r){r.d(t,{i$:()=>n,xJ:()=>i}),r(47635),r(6627);var o=r(33),a=r(62462);function i(e){e.vertex.uniforms.add(new o.E("nearFar",e=>e.camera.nearFar))}function n(e){e.vertex.code.add(a.H`float calculateLinearDepth(vec2 nearFar,float z) {
return (-z - nearFar[0]) / (nearFar[1] - nearFar[0]);
}`)}},29785(e,t,r){r.d(t,{M:()=>a});var o=r(62462);function a(e){e.vertex.code.add(o.H`vec4 offsetBackfacingClipPosition(vec4 posClip, vec3 posWorld, vec3 normalWorld, vec3 camPosWorld) {
vec3 camToVert = posWorld - camPosWorld;
bool isBackface = dot(camToVert, normalWorld) > 0.0;
if (isBackface) {
posClip.z += 0.0000003 * posClip.w;
}
return posClip;
}`)}},77788(e,t,r){function o(e){return function(e){return c(e)||4===e}(e)||function(e){return 5===(t=e)||6===t||7===t||8===e||9===e;var t}(e)}function a(e){return 10===e||11===e}function i(e){return l(e)||a(e)}function n(e){return 1===e}function s(e){return 2===e}function l(e){return 0===e||function(e){return n(e)||s(e)}(e)}function c(e){return function(e){return l(e)||a(e)}(e)||d(e)}function d(e){return 3===e}r.d(t,{Ex:()=>a,Rb:()=>s,_$:()=>n,_o:()=>l,eh:()=>d,gr:()=>c,i3:()=>i,uw:()=>o})},31790(e,t,r){r.d(t,{d:()=>i});var o=r(14225),a=r(62462);function i(e){(0,o.i$)(e),e.vertex.code.add(a.H`vec4 transformPositionWithDepth(mat4 proj, mat4 view, vec3 pos, vec2 nearFar, out float depth) {
vec4 eye = view * vec4(pos, 1.0);
depth = calculateLinearDepth(nearFar,eye.z);
return proj * eye;
}`),e.vertex.code.add(a.H`vec4 transformPosition(mat4 proj, mat4 view, vec3 pos) {
return proj * (view * vec4(pos, 1.0));
}`)}},37716(e,t,r){r.d(t,{v:()=>i});var o=r(44418),a=r(62462);function i(e,t){t.instancedColor?(e.attributes.add("instanceColor","vec4"),e.vertex.include(o.WD),e.vertex.include(o.Y1),e.vertex.include(o.ML),e.vertex.code.add(a.H`
      MaskedColor applyInstanceColor(MaskedColor color) {
        return multiplyMaskedColors( color, createMaskedFromUInt8NaNColor(${"instanceColor"}));
      }
    `)):e.vertex.code.add(a.H`MaskedColor applyInstanceColor(MaskedColor color) {
return color;
}`)}},65028(e,t,r){r.d(t,{B:()=>g});var o=r(82541),a=r(79441),i=r(26110),n=r(71573),s=r(19913),l=r(30588),c=r(21586),d=r(9504),u=r(62462),h=r(19835),m=r(29162);class p extends m.n{constructor(e,t,r){super(e,"mat4",1,(o,a,i)=>o.setUniformMatrix4fv(e,t(a,i),r))}}var f=r(3016);r(13439).Y;const v=(0,a.vt)();function g(e,t){const{hasModelTransformation:r,instancedDoublePrecision:a,instanced:s,output:m,hasVertexTangents:g}=t;r&&(e.vertex.uniforms.add(new p("model",e=>e.modelTransformation??i.zK)),e.vertex.uniforms.add(new h.k("normalLocalOriginFromModel",e=>((0,o.Ge)(v,e.modelTransformation??i.zK),v)))),s&&a&&(e.attributes.add("instanceModelOriginHi","vec3"),e.attributes.add("instanceModelOriginLo","vec3"),e.attributes.add("instanceModel","mat3"),e.attributes.add("instanceModelNormal","mat3"));const b=e.vertex;a&&(b.include(l.u),b.uniforms.add(new d.d("viewOriginHi",e=>(0,f.Zo)((0,n.hZ)(x,e.camera.viewInverseTransposeMatrix[3],e.camera.viewInverseTransposeMatrix[7],e.camera.viewInverseTransposeMatrix[11]),x)),new d.d("viewOriginLo",e=>(0,f.jA)((0,n.hZ)(x,e.camera.viewInverseTransposeMatrix[3],e.camera.viewInverseTransposeMatrix[7],e.camera.viewInverseTransposeMatrix[11]),x)))),b.code.add(u.H`
    vec3 getVertexInLocalOriginSpace() {
      return ${r?a?"(model * vec4(instanceModel * localPosition().xyz, 1.0)).xyz":"(model * localPosition()).xyz":a?"instanceModel * localPosition().xyz":"localPosition().xyz"};
    }

    vec3 subtractOrigin(vec3 _pos) {
      ${a?u.H`
          // Issue: (should be resolved now with invariant position) https://devtopia.esri.com/WebGIS/arcgis-js-api/issues/56280
          vec3 originDelta = dpAdd(viewOriginHi, viewOriginLo, -instanceModelOriginHi, -instanceModelOriginLo);
          return _pos - originDelta;`:"return vpos;"}
    }
    `),b.code.add(u.H`
    vec3 dpNormal(vec4 _normal) {
      return normalize(${r?a?"normalLocalOriginFromModel * (instanceModelNormal * _normal.xyz)":"normalLocalOriginFromModel * _normal.xyz":a?"instanceModelNormal * _normal.xyz":"_normal.xyz"});
    }
    `),4===m&&((0,c.S7)(b),b.code.add(u.H`
    vec3 dpNormalView(vec4 _normal) {
      return normalize((viewNormal * ${r?a?"vec4(normalLocalOriginFromModel * (instanceModelNormal * _normal.xyz), 1.0)":"vec4(normalLocalOriginFromModel * _normal.xyz, 1.0)":a?"vec4(instanceModelNormal * _normal.xyz, 1.0)":"_normal"}).xyz);
    }
    `)),g&&b.code.add(u.H`
    vec4 dpTransformVertexTangent(vec4 _tangent) {
      ${r?a?"return vec4(normalLocalOriginFromModel * (instanceModelNormal * _tangent.xyz), _tangent.w);":"return vec4(normalLocalOriginFromModel * _tangent.xyz, _tangent.w);":a?"return vec4(instanceModelNormal * _tangent.xyz, _tangent.w);":"return _tangent;"}
    }`)}const x=(0,s.vt)()},3525(e,t,r){r.d(t,{Y:()=>a});var o=r(62462);function a(e,t){switch(e.fragment.code.add(o.H`vec3 screenDerivativeNormal(vec3 positionView) {
return normalize(cross(dFdx(positionView), dFdy(positionView)));
}`),t.normalType){case 1:e.attributes.add("normalCompressed","vec2"),e.vertex.code.add(o.H`vec3 decompressNormal(vec2 normal) {
float z = 1.0 - abs(normal.x) - abs(normal.y);
return vec3(normal + sign(normal) * min(z, 0.0), z);
}
vec3 normalModel() {
return decompressNormal(normalCompressed);
}`);break;case 0:e.attributes.add("normal","vec3"),e.vertex.code.add(o.H`vec3 normalModel() {
return normal;
}`);break;default:t.normalType;case 2:case 3:}}},79887(e,t,r){r.d(t,{K:()=>s});var o=r(44418),a=r(62462),i=r(88531),n=r(73395);function s(e,t){e.varyings.add("colorMixMode","int"),e.varyings.add("opacityMixMode","int"),e.vertex.uniforms.add(new i.c("symbolColorMixMode",e=>n.Um[e.colorMixMode])),t.hasSymbolColors?(e.vertex.include(o.WD),e.vertex.include(o.Y1),e.vertex.include(o.ML),e.attributes.add("symbolColor","vec4"),e.vertex.code.add(a.H`
    MaskedColor applySymbolColor(MaskedColor color) {
      return multiplyMaskedColors(color, createMaskedFromUInt8NaNColor(${"symbolColor"}));
    }
  `)):e.vertex.code.add(a.H`MaskedColor applySymbolColor(MaskedColor color) {
return color;
}`),e.vertex.code.add(a.H`
    void forwardColorMixMode(bvec4 mask) {
      colorMixMode = mask.r ? ${a.H.int(n.Um.ignore)} : symbolColorMixMode;
      opacityMixMode = mask.a ? ${a.H.int(n.Um.ignore)} : symbolColorMixMode;
    }
  `)}},51229(e,t,r){r.d(t,{U:()=>a});var o=r(62462);function a(e,t){switch(t.textureCoordinateType){case 1:return e.attributes.add("uv0","vec2"),e.varyings.add("vuv0","vec2"),void e.vertex.code.add(o.H`void forwardTextureCoordinates() { vuv0 = uv0; }`);case 2:return e.attributes.add("uv0","vec2"),e.attributes.add("uvRegion","vec4"),e.varyings.add("vuv0","vec2"),e.varyings.add("vuvRegion","vec4"),void e.vertex.code.add(o.H`void forwardTextureCoordinates() {
vuv0 = uv0;
vuvRegion = uvRegion;
}`);default:t.textureCoordinateType;case 0:return void e.vertex.code.add(o.H`void forwardTextureCoordinates() {}`);case 3:return}}},73713(e,t,r){r.d(t,{c:()=>a});var o=r(62462);function a(e,t){t.hasVertexColors?(e.attributes.add("color","vec4"),e.varyings.add("vColor","vec4"),e.vertex.code.add(o.H`void forwardVertexColor() { vColor = color; }`)):e.vertex.code.add(o.H`void forwardVertexColor() {}`)}},83143(e,t,r){r.d(t,{Mh:()=>c,Zo:()=>d,gy:()=>u});var o=r(79441),a=r(76982),i=r(3525),n=r(6627),s=r(62462),l=r(19835);function c(e,t){const{vertex:r,varyings:o}=e;switch(t.normalType){case 0:case 1:e.include(i.Y,t),o.add("vNormalWorld","vec3"),o.add("vNormalView","vec3"),r.uniforms.add(new l.k("transformNormalViewFromGlobal",e=>e.transformNormalViewFromGlobal)),r.code.add(s.H`void forwardNormal() {
vNormalWorld = normalModel();
vNormalView = transformNormalViewFromGlobal * vNormalWorld;
}`);break;case 2:e.vertex.code.add(s.H`void forwardNormal() {}`);break;default:t.normalType;case 3:}}class d extends n.dO{constructor(){super(...arguments),this.transformNormalViewFromGlobal=(0,o.vt)()}}class u extends n.EM{constructor(){super(...arguments),this.toMapSpace=(0,a.vt)()}}},6627(e,t,r){r.d(t,{EM:()=>l,dO:()=>s});var o=r(79441),a=r(19913),i=(r(30588),r(223),r(64802),r(62462),r(29162));i.n,i.n,r(19835),r(7574),r(19778);var n=r(13439);class s extends n.Y{constructor(){super(...arguments),this.transformWorldFromViewTH=(0,a.vt)(),this.transformWorldFromViewTL=(0,a.vt)(),this.transformViewFromCameraRelativeRS=(0,o.vt)()}}class l extends n.Y{constructor(){super(...arguments),this.transformWorldFromModelRS=(0,o.vt)(),this.transformWorldFromModelTH=(0,a.vt)(),this.transformWorldFromModelTL=(0,a.vt)(),this.transformationDrawId=0}}},2169(e,t,r){r.d(t,{r:()=>n});var o=r(51229),a=r(62462);function i(e){e.fragment.code.add(a.H`vec4 textureAtlasLookup(sampler2D tex, vec2 textureCoordinates, vec4 atlasRegion) {
vec2 atlasScale = atlasRegion.zw - atlasRegion.xy;
vec2 uvAtlas = fract(textureCoordinates) * atlasScale + atlasRegion.xy;
float maxdUV = 0.125;
vec2 dUVdx = clamp(dFdx(textureCoordinates), -maxdUV, maxdUV) * atlasScale;
vec2 dUVdy = clamp(dFdy(textureCoordinates), -maxdUV, maxdUV) * atlasScale;
return textureGrad(tex, uvAtlas, dUVdx, dUVdy);
}`)}function n(e,t){const{textureCoordinateType:r}=t;if(0===r||3===r)return;e.include(o.U,t);const n=2===r;n&&e.include(i),e.fragment.code.add(a.H`
    vec4 textureLookup(sampler2D tex, vec2 uv) {
      return ${n?"textureAtlasLookup(tex, uv, vuvRegion)":"texture(tex, uv)"};
    }
  `)}},11255(e,t,r){r.d(t,{Ge:()=>c}),r(23572);var o=r(71072),a=r(76982),i=r(15510),n=r(21586),s=r(92121),l=r(62462);function c(e,t){const r=e.vertex;t.hasVerticalOffset?(function(e){e.uniforms.add(new s.E("verticalOffset",(e,t)=>{const{minWorldLength:r,maxWorldLength:a,screenLength:i}=e.verticalOffset,n=Math.tan(.5*t.camera.fovY)/(.5*t.camera.fullViewport[3]),s=t.camera.pixelRatio||1;return(0,o.hZ)(d,i*s,n,r,a)}))}(r),t.hasScreenSizePerspective&&(e.include(i.Y6),(0,i.OH)(r),(0,n.yu)(e.vertex,t)),r.code.add(l.H`
      vec3 calculateVerticalOffset(vec3 worldPos, vec3 localOrigin) {
        float viewDistance = length((view * vec4(worldPos, 1.0)).xyz);
        ${t.spherical?l.H`vec3 worldNormal = normalize(worldPos + localOrigin);`:l.H`vec3 worldNormal = vec3(0.0, 0.0, 1.0);`}
        ${t.hasScreenSizePerspective?l.H`
            float cosAngle = dot(worldNormal, normalize(worldPos - cameraPosition));
            float verticalOffsetScreenHeight = screenSizePerspectiveScaleFloat(verticalOffset.x, abs(cosAngle), viewDistance, screenSizePerspectiveAlignment);`:l.H`
            float verticalOffsetScreenHeight = verticalOffset.x;`}
        // Screen sized offset in world space, used for example for line callouts
        float worldOffset = clamp(verticalOffsetScreenHeight * verticalOffset.y * viewDistance, verticalOffset.z, verticalOffset.w);
        return worldNormal * worldOffset;
      }

      vec3 addVerticalOffset(vec3 worldPos, vec3 localOrigin) {
        return worldPos + calculateVerticalOffset(worldPos, localOrigin);
      }
    `)):r.code.add(l.H`vec3 addVerticalOffset(vec3 worldPos, vec3 localOrigin) { return worldPos; }`)}const d=(0,a.vt)()},70194(e,t,r){r.d(t,{E:()=>g});var o=r(14225),a=r(24615),i=r(31790),n=r(3525),s=r(38587),l=r(51229),c=r(83143),d=r(62462);function u(e,t){switch(t.output){case 5:case 6:case 7:case 8:e.fragment.code.add(d.H`float _calculateFragDepth(const in float depth) {
const float slope_scale = 2.0;
const float bias = 20.0 * .000015259;
float m = max(abs(dFdx(depth)), abs(dFdy(depth)));
return depth + slope_scale * m + bias;
}
void outputDepth(float _linearDepth){
float fragDepth = _calculateFragDepth(_linearDepth);
gl_FragDepth = fragDepth;
}`);break;case 9:e.fragment.code.add(d.H`void outputDepth(float _linearDepth){
gl_FragDepth = _linearDepth;
}`)}}var h=r(20524),m=r(69410),p=r(73349),f=r(21586),v=r(19778);function g(e,t){const{vertex:r,fragment:g,varyings:x}=e,{hasColorTexture:b,alphaDiscardMode:y}=t,w=b&&1!==y,{output:M,normalType:S,hasColorTextureTransform:T}=t;switch(M){case 3:(0,f.NB)(r,t),e.include(i.d),g.include(a.HQ,t),e.include(l.U,t),w&&g.uniforms.add(new v.N("tex",e=>e.texture)),r.main.add(d.H`vpos = getVertexInLocalOriginSpace();
vpos = subtractOrigin(vpos);
vpos = addVerticalOffset(vpos, localOrigin);
gl_Position = transformPosition(proj, view, vpos);
forwardTextureCoordinates();`),e.include(p.S,t),g.main.add(d.H`
        discardBySlice(vpos);
        ${(0,d.If)(w,d.H`vec4 texColor = texture(tex, ${T?"colorUV":"vuv0"});
                discardOrAdjustAlpha(texColor);`)}`);break;case 5:case 6:case 7:case 8:case 11:(0,f.NB)(r,t),e.include(i.d),e.include(l.U,t),e.include(m.A,t),e.include(u,t),g.include(a.HQ,t),e.include(s.g,t),(0,o.xJ)(e),x.add("depth","float",{invariant:!0}),w&&g.uniforms.add(new v.N("tex",e=>e.texture)),r.main.add(d.H`vpos = getVertexInLocalOriginSpace();
vpos = subtractOrigin(vpos);
vpos = addVerticalOffset(vpos, localOrigin);
gl_Position = transformPositionWithDepth(proj, view, vpos, nearFar, depth);
forwardTextureCoordinates();
forwardObjectAndLayerIdColor();`),e.include(p.S,t),g.main.add(d.H`
        discardBySlice(vpos);
        ${(0,d.If)(w,d.H`vec4 texColor = texture(tex, ${T?"colorUV":"vuv0"});
               discardOrAdjustAlpha(texColor);`)}
        ${11===M?d.H`outputObjectAndLayerIdColor();`:d.H`outputDepth(depth);`}`);break;case 4:{(0,f.NB)(r,t),e.include(i.d),e.include(n.Y,t),e.include(c.Mh,t),e.include(l.U,t),e.include(m.A,t),w&&g.uniforms.add(new v.N("tex",e=>e.texture)),2===S&&x.add("vPositionView","vec3",{invariant:!0});const o=0===S||1===S;r.main.add(d.H`
        vpos = getVertexInLocalOriginSpace();
        ${o?d.H`vNormalWorld = dpNormalView(vvLocalNormal(normalModel()));`:d.H`vPositionView = (view * vec4(vpos, 1.0)).xyz;`}
        vpos = subtractOrigin(vpos);
        vpos = addVerticalOffset(vpos, localOrigin);
        gl_Position = transformPosition(proj, view, vpos);
        forwardTextureCoordinates();`),g.include(a.HQ,t),e.include(p.S,t),g.main.add(d.H`
        discardBySlice(vpos);
        ${(0,d.If)(w,d.H`vec4 texColor = texture(tex, ${T?"colorUV":"vuv0"});
                discardOrAdjustAlpha(texColor);`)}

        ${2===S?d.H`vec3 normal = screenDerivativeNormal(vPositionView);`:d.H`vec3 normal = normalize(vNormalWorld);
                    if (gl_FrontFacing == false){
                      normal = -normal;
                    }`}
        fragColor = vec4(0.5 + 0.5 * normal, 1.0);`);break}case 10:(0,f.NB)(r,t),e.include(i.d),e.include(l.U,t),e.include(m.A,t),w&&g.uniforms.add(new v.N("tex",e=>e.texture)),r.main.add(d.H`vpos = getVertexInLocalOriginSpace();
vpos = subtractOrigin(vpos);
vpos = addVerticalOffset(vpos, localOrigin);
gl_Position = transformPosition(proj, view, vpos);
forwardTextureCoordinates();`),g.include(a.HQ,t),e.include(p.S,t),e.include(h.Q,t),g.main.add(d.H`
        discardBySlice(vpos);
        ${(0,d.If)(w,d.H`vec4 texColor = texture(tex, ${T?"colorUV":"vuv0"});
                discardOrAdjustAlpha(texColor);`)}
        calculateOcclusionAndOutputHighlight();`)}}},6750(e,t,r){r.d(t,{NL:()=>p});var o=r(4506),a=r(77788),i=r(2169),n=r(56926),s=r(223),l=r(64802),c=r(20146),d=r(19635),u=r(62462),h=r(29247),m=r(19778);function p(e,t){if(!(0,a._o)(t.output))return;e.fragment.include(n.C);const{emissionSource:r,hasEmissiveTextureTransform:p,bindType:f}=t,v=3===r||4===r||5===r;v&&(e.include(i.r,t),e.fragment.uniforms.add(1===f?new m.N("texEmission",e=>e.textureEmissive):new h.o("texEmission",e=>e.textureEmissive)));const g=2===r||v;g&&e.fragment.uniforms.add(1===f?new l.t("emissiveBaseColor",e=>e.emissiveBaseColor):new s.W("emissiveBaseColor",e=>e.emissiveBaseColor));const x=0!==r;if(x&&7!==r&&6!==r&&4!==r&&5!==r){const t=e=>(0,o.qE)(e??0,0,16);e.fragment.uniforms.add(1===f?new d.m("emissiveStrength",e=>t(e.emissiveStrength)):new c.J("emissiveStrength",e=>t(e.emissiveStrength)))}const b=7===r,y=5===r,w=1===r||6===r||b;e.fragment.code.add(u.H`
    vec4 getEmissions(vec3 symbolColor) {
      vec4 emissions = ${g?y?"emissiveSource == 0 ? vec4(emissiveBaseColor, 1.0): vec4(linearizeGamma(symbolColor), 1.0)":"vec4(emissiveBaseColor, 1.0)":w?b?"emissiveSource == 0 ? vec4(0.0): vec4(linearizeGamma(symbolColor), 1.0)":"vec4(linearizeGamma(symbolColor), 1.0)":"vec4(0.0)"};
      ${(0,u.If)(v,`${(0,u.If)(y,`if(emissiveSource == 0) {\n              vec4 emissiveFromTex = textureLookup(texEmission, ${p?"emissiveUV":"vuv0"});\n              emissions *= vec4(linearizeGamma(emissiveFromTex.rgb), emissiveFromTex.a);\n           }`,`vec4 emissiveFromTex = textureLookup(texEmission, ${p?"emissiveUV":"vuv0"});\n           emissions *= vec4(linearizeGamma(emissiveFromTex.rgb), emissiveFromTex.a);`)}\n        emissions.a = emissions.rgb == vec3(0.0) ? 0.0: emissions.a;`)}
      ${(0,u.If)(x,`emissions.rgb *= emissiveStrength * ${u.H.float(1)};`)}
      return emissions;
    }
  `)}r(41414)},16937(e,t,r){r.d(t,{E:()=>s,l:()=>l});var o=r(53334),a=r(56560),i=r(33),n=r(62462);function s(e){e.uniforms.add(new i.E("zProjectionMap",e=>l(e.camera))),e.code.add(n.H`float linearizeDepth(float depth, vec2 zProjectionConstants) {
float depthNdc = depth * 2.0 - 1.0;
return -(zProjectionConstants[0] / (depthNdc + zProjectionConstants[1] + 1e-7));
}
float linearizeDepth(float depth) {
return linearizeDepth(depth, zProjectionMap);
}`),e.code.add(n.H`float delinearizeDepth(float linearDepth) {
float c1 = zProjectionMap[0];
float c2 = zProjectionMap[1];
float depthNdc = (-c1/linearDepth) - c2 - 1e-7;
float depthNonlinear01 = (depthNdc + 1.0 ) / 2.0;
return depthNonlinear01;
}`),e.code.add(n.H`float depthFromTexture(sampler2D depthTexture, vec2 uv) {
ivec2 iuv = ivec2(uv * vec2(textureSize(depthTexture, 0)));
return texelFetch(depthTexture, iuv, 0).r;
}`),e.code.add(n.H`float linearDepthFromTexture(sampler2D depthTexture, vec2 uv) {
return linearizeDepth(depthFromTexture(depthTexture, uv));
}`)}function l(e){const t=e.projectionMatrix;return(0,o.hZ)(c,t[14],t[10])}const c=(0,a.vt)()},11422(e,t,r){r.d(t,{V:()=>n});var o=r(16937),a=r(33),i=r(62462);function n(e){e.include(o.E),e.uniforms.add(new a.E("zProjectionMapLastFrame",e=>(0,o.l)(e.reprojection.lastFrameCamera))),e.code.add(i.H`float linearDepthFromTextureLastFrame(sampler2D depthTexture, vec2 uv) {
return linearizeDepth(depthFromTexture(depthTexture, uv), zProjectionMapLastFrame);
}`)}},50710(e,t,r){r.d(t,{J:()=>h});var o=r(79441),a=r(56560),i=r(2169),n=r(37138),s=r(66579),l=r(62462),c=r(19835),d=r(29247),u=r(19778);function h(e,t){return function(e,t){const r=e.fragment,{hasVertexTangents:h,doubleSidedMode:m,hasNormalTexture:p,textureCoordinateType:f,bindType:v,hasNormalTextureTransform:g}=t;h?(e.attributes.add("tangent","vec4"),e.varyings.add("vTangent","vec4"),2===m?r.code.add(l.H`mat3 computeTangentSpace(vec3 normal) {
float tangentHeadedness = gl_FrontFacing ? vTangent.w : -vTangent.w;
vec3 tangent = normalize(gl_FrontFacing ? vTangent.xyz : -vTangent.xyz);
vec3 bitangent = cross(normal, tangent) * tangentHeadedness;
return mat3(tangent, bitangent, normal);
}`):r.code.add(l.H`mat3 computeTangentSpace(vec3 normal) {
float tangentHeadedness = vTangent.w;
vec3 tangent = normalize(vTangent.xyz);
vec3 bitangent = cross(normal, tangent) * tangentHeadedness;
return mat3(tangent, bitangent, normal);
}`)):r.code.add(l.H`mat3 computeTangentSpace(vec3 normal, vec3 pos, vec2 st) {
vec3 Q1 = dFdx(pos);
vec3 Q2 = dFdy(pos);
vec2 stx = dFdx(st);
vec2 sty = dFdy(st);
float det = stx.t * sty.s - sty.t * stx.s;
vec3 T = stx.t * Q2 - sty.t * Q1;
T = T - normal * dot(normal, T);
T *= inversesqrt(max(dot(T,T), 1.e-10));
vec3 B = sign(det) * cross(normal, T);
return mat3(T, B, normal);
}`),p&&0!==f&&(e.include(i.r,t),r.uniforms.add(1===v?new u.N("normalTexture",e=>e.textureNormal):new d.o("normalTexture",e=>e.textureNormal)),g&&(r.uniforms.add(1===v?new s.G("scale",e=>e.scale??a.Un):new n.t("scale",e=>e.scale??a.Un)),r.uniforms.add(new c.k("normalTextureTransformMatrix",e=>e.normalTextureTransformMatrix??o.zK))),r.code.add(l.H`vec3 computeTextureNormal(mat3 tangentSpace, vec2 uv) {
vec3 rawNormal = textureLookup(normalTexture, uv).rgb * 2.0 - 1.0;`),g&&r.code.add(l.H`mat3 normalRotation = mat3(normalTextureTransformMatrix[0][0]/scale[0], normalTextureTransformMatrix[0][1]/scale[1], 0.0,
normalTextureTransformMatrix[1][0]/scale[0], normalTextureTransformMatrix[1][1]/scale[1], 0.0,
0.0, 0.0, 0.0 );
rawNormal.xy = (normalRotation * vec3(rawNormal.x, rawNormal.y, 1.0)).xy;`),r.code.add(l.H`return tangentSpace * rawNormal;
}`))}(e,t)}},87646(e,t,r){r.d(t,{n:()=>F});var o=r(62462),a=r(96384),i=r(31635),n=r(4506),s=r(57725),l=r(61985),c=r(67900),d=r(69636),u=r(53334),h=r(14298),m=r(90238),p=r(43300),f=r(70051),v=r(73218),g=r(26599),x=r(15651);let b=class extends v.w{constructor(){super(...arguments),this.shader=new f.r(g.S,()=>r.e(7920).then(r.bind(r,87920)))}initializePipeline(){return(0,x.Ey)({colorWrite:x.kn})}};b=(0,i.Cg)([(0,d.$K)("esri.views.3d.webgl-engine.effects.ssao.SSAOBlurTechnique")],b);var y=r(56560),w=r(13439);class M extends w.Y{constructor(){super(...arguments),this.projScale=1}}class S extends M{constructor(){super(...arguments),this.intensity=1}}class T extends w.Y{}class C extends T{constructor(){super(...arguments),this.blurSize=(0,y.vt)()}}let I=class extends v.w{constructor(){super(...arguments),this.shader=new f.r(p.S,()=>r.e(7447).then(r.bind(r,87447)))}initializePipeline(){return(0,x.Ey)({colorWrite:x.kn})}};I=(0,i.Cg)([(0,d.$K)("esri.views.3d.webgl-engine.effects.ssao.SSAOTechnique")],I),r(68716);var _=r(89958),P=r(88416);let z=class extends m.A{constructor(e){super(e),this.consumes={required:["normals"]},this.produces=h.OG.AMBIENT_ILLUMINATION,this._enableTime=(0,c.l5)(0),this._passParameters=new S,this._drawParameters=new C}initialize(){const e=Uint8Array.from(atob("eXKEvZaUc66cjIKElE1jlJ6MjJ6Ufkl+jn2fcXp5jBx7c6KEflSGiXuXeW6OWs+tfqZ2Yot2Y7Zzfo2BhniEj3xoiXuXj4eGZpqEaHKDWjSMe7palFlzc3BziYOGlFVzg6Zzg7CUY5JrjFF7eYJ4jIKEcyyEonSXe7qUfqZ7j3xofqZ2c4R5lFZ5Y0WUbppoe1l2cIh2ezyUho+BcHN2cG6DbpqJhqp2e1GcezhrdldzjFGUcyxjc3aRjDyEc1h7Sl17c6aMjH92pb6Mjpd4dnqBjMOEhqZleIOBYzB7gYx+fnqGjJuEkWlwnCx7fGl+c4hjfGyRe5qMlNOMfnqGhIWHc6OMi4GDc6aMfqZuc6aMzqJzlKZ+lJ6Me3qRfoFue0WUhoR5UraEa6qMkXiPjMOMlJOGe7JrUqKMjK6MeYRzdod+Sl17boiPc6qEeYBlcIh2c1WEe7GDiWCDa0WMjEmMdod+Y0WcdntzhmN8WjyMjKJjiXtzgYxYaGd+a89zlEV7e2GJfnd+lF1rcK5zc4p5cHuBhL6EcXp5eYB7fnh8iX6HjIKEeaxuiYOGc66RfG2Ja5hzjlGMjEmMe9OEgXuPfHyGhPeEdl6JY02McGuMfnqGhFiMa3WJfnx2l4hwcG1uhmN8c0WMc39og1GBbrCEjE2EZY+JcIh2cIuGhIWHe0mEhIVrc09+gY5+eYBlnCyMhGCDl3drfmmMgX15aGd+gYx+fnuRfnhzY1SMsluJfnd+hm98WtNrcIuGh4SEj0qPdkqOjFF7jNNjdnqBgaqUjMt7boeBhnZ4jDR7c5pze4GGjEFrhLqMjHyMc0mUhKZze4WEa117kWlwbpqJjHZ2eX2Bc09zeId+e0V7WlF7jHJ2l72BfId8l3eBgXyBe897jGl7c66cgW+Xc76EjKNbgaSEjGx4fId8jFFjgZB8cG6DhlFziZhrcIh2fH6HgUqBgXiPY8dahGFzjEmMhEFre2dxhoBzc5SGfleGe6alc7aUeYBlhKqUdlp+cH5za4OEczxza0Gcc4J2jHZ5iXuXjH2Jh5yRjH2JcFx+hImBjH+MpddCl3dreZeJjIt8ZW18bm1zjoSEeIOBlF9oh3N7hlqBY4+UeYFwhLJjeYFwaGd+gUqBYxiEYot2fqZ2ondzhL6EYyiEY02Ea0VjgZB8doaGjHxoc66cjEGEiXuXiXWMiZhreHx8frGMe75rY02Ec5pzfnhzlEp4a3VzjM+EhFFza3mUY7Zza1V5e2iMfGyRcziEhDyEkXZ2Y4OBnCx7g5t2eyBjgV6EhEFrcIh2dod+c4Z+nJ5zjm15jEmUeYxijJp7nL6clIpjhoR5WrZraGd+fnuRa6pzlIiMg6ZzfHx5foh+eX1ufnB5eX1ufnB5aJt7UqKMjIh+e3aBfm5lbYSBhGFze6J4c39oc0mUc4Z+e0V7fKFVe0WEdoaGY02Ec4Z+Y02EZYWBfH6HgU1+gY5+hIWUgW+XjJ57ebWRhFVScHuBfJ6PhBx7WqJzlM+Ujpd4gHZziX6HjHmEgZN+lJt5boiPe2GJgX+GjIGJgHZzeaxufnB5hF2JtdN7jJ57hp57hK6ElFVzg6ZzbmiEbndzhIWHe3uJfoFue3qRhJd2j3xoc65zlE1jc3p8lE1jhniEgXJ7e657vZaUc3qBh52BhIF4aHKDa9drgY5+c52GWqZzbpqJe8tjnM+UhIeMfo2BfGl+hG1zSmmMjKJjZVaGgX15c1lze0mEp4OHa3mUhIWHhDyclJ6MeYOJkXiPc0VzhFiMlKaEboSJa5Jze41re3qRhn+HZYWBe0mEc4p5fnORbox5lEp4hGFjhGGEjJuEc1WEhLZjeHeGa7KlfHx2hLaMeX1ugY5+hIWHhKGPjMN7c1WEho1zhoBzZYx7fnhzlJt5exyUhFFziXtzfmmMa6qMYyiEiXxweV12kZSMeWqXSl17fnhzxmmMrVGEe1mcc4p5eHeGjK6MgY5+doaGa6pzlGV7g1qBh4KHkXiPeW6OaKqafqZ2eXZ5e1V7jGd7boSJc3BzhJd2e0mcYot2h1RoY8dahK6EQmWEWjx7e1l2lL6UgXyBdnR4eU9zc0VreX1umqaBhld7fo2Bc6KEc5Z+hDyEcIeBWtNrfHyGe5qMhMuMe5qMhEGEbVVupcNzg3aHhIF4boeBe0mEdlptc39ofFl5Y8uUlJOGiYt2UmGEcyxjjGx4jFF7a657ZYWBnElzhp57iXtrgZN+tfOEhIOBjE2HgU1+e8tjjKNbiWCDhE15gUqBgYN7fnqGc66ce9d7iYSBj0qPcG6DnGGcT3eGa6qMZY+JlIiMl4hwc3aRdnqBlGV7eHJ2hLZjfnuRhDyEeX6MSk17g6Z+c6aUjHmEhIF4gXyBc76EZW18fGl+fkl+jCxrhoVwhDyUhIqGlL2DlI6EhJd2tdN7eYORhEGMa2Faa6pzc3Bzc4R5lIRznM+UY9eMhDycc5Z+c4p5c4iGY117pb6MgXuPrbJafnx2eYOJeXZ5e657hDyEcziElKZjfoB5eHeGj4WRhGGEe6KGeX1utTStc76EhFGJnCyMa5hzfH6HnNeceYB7hmN8gYuMhIVrczSMgYF8h3N7c5pza5hzjJqEYIRdgYuMlL2DeYRzhGGEeX1uhLaEc4iGeZ1zdl6JhrVteX6Me2iMfm5lWqJzSpqEa6pzdnmchHx2c6OMhNdrhoR5g3aHczxzeW52gV6Ejm15frGMc0Vzc4Z+l3drfniJe+9rWq5rlF1rhGGEhoVwe9OEfoh+e7pac09+c3qBY0lrhDycdnp2lJ6MiYOGhGCDc3aRlL2DlJt5doaGdnp2gYF8gWeOjF2Uc4R5c5Z+jEmMe7KEc4mEeYJ4dmyBe0mcgXiPbqJ7eYB7fmGGiYSJjICGlF1reZ2PnElzbpqJfH6Hc39oe4WEc5eJhK6EhqyJc3qBgZB8c09+hEmEaHKDhFGJc5SGiXWMUpaEa89zc6OMnCyMiXtrho+Be5qMc7KEjJ57dmN+hKGPjICGbmiEe7prdod+hGCDdnmchBx7eX6MkXZ2hGGEa657hm98jFFjY5JreYOJgY2EjHZ2a295Y3FajJ6Mc1J+YzB7e4WBjF2Uc4R5eV12gYxzg1qBeId+c9OUc5pzjFFjgY5+hFiMlIaPhoR5lIpjjIKBlNdSe7KEeX2BfrGMhIqGc65zjE2UhK6EklZ+QmWEeziMWqZza3VzdnR4foh+gYF8n3iJiZhrnKp7gYF8eId+lJ6Me1lrcIuGjKJjhmN8c66MjFF7a6prjJ6UnJ5zezyUfruRWlF7nI5zfHyGe657h4SEe8tjhBx7jFFjc09+c39ojICMeZeJeXt+YzRzjHZ2c0WEcIeBeXZ5onSXkVR+gYJ+eYFwdldzgYF7eX2BjJ6UiXuXlE1jh4SEe1mchLJjc4Z+hqZ7eXZ5bm1zlL6Ue5p7iWeGhKqUY5pzjKJjcIeBe8t7gXyBYIRdlEp4a3mGnK6EfmmMZpqEfFl5gYxzjKZuhGFjhoKGhHx2fnx2eXuMe3aBiWeGvbKMe6KGa5hzYzB7gZOBlGV7hmN8hqZlYot2Y117a6pzc6KEfId8foB5rctrfneJfJ6PcHN2hFiMc5pzjH92c0VzgY2EcElzdmCBlFVzg1GBc65zY4OBboeBcHiBeYJ4ewxzfHx5lIRzlEmEnLKEbk1zfJ6PhmN8eYBljBiEnMOEiXxwezyUcIeBe76EdsKEeX2BdnR4jGWUrXWMjGd7fkl+j4WRlEGMa5Jzho+BhDyEfnqMeXt+g3aHlE1jczClhNN7ZW18eHx8hGFjZW18iXWMjKJjhH57gYuMcIuGWjyMe4ZtjJuExmmMj4WRdntzi4GDhFFzYIRdnGGcjJp7Y0F7e4WEkbCGiX57fnSHa657a6prhBCMe3Z+SmmMjH92eHJ2hK6EY1FzexhrvbKMnI5za4OEfnd+eXuMhImBe897hLaMjN+EfG+BeIOBhF1+eZeJi4GDkXZ2eXKEgZ6Ejpd4c2GHa1V5e5KUfqZuhCx7jKp7lLZrg11+hHx2hFWUoot2nI5zgbh5mo9zvZaUe3qRbqKMfqZ2kbCGhFiM"),e=>e.charCodeAt(0)),t=new P.R(32);t.wrapMode=33071,t.pixelFormat=6407,t.wrapMode=10497,t.hasMipmap=!0,this._passParameters.noiseTexture=new _.A(this.renderingContext,t,e),this.addHandles((0,l.wB)(()=>this.view.stage.renderer.hasAmbientIllumination,()=>this._enableTime=(0,c.l5)(0)))}destroy(){this._passParameters.noiseTexture=(0,s.WD)(this._passParameters.noiseTexture)}render(e){const t=e.find(({name:e})=>"normals"===e),r=t?.getTexture(),o=t?.getTexture(33306);if(!r||!o)return;const a=this.techniques.getCompiled(I),i=this.techniques.getCompiled(b);if(!a||!i)return this._enableTime=(0,c.l5)(performance.now()),void this.requestRender(1);0===this._enableTime&&(this._enableTime=(0,c.l5)(performance.now()));const s=this.renderingContext,l=this.view.qualitySettings.fadeDuration,d=this.bindParameters,m=d.camera,f=m.relativeElevation,v=(0,n.qE)((5e5-f)/2e5,0,1),g=l>0?Math.min(l,performance.now()-this._enableTime)/l:1,x=g*v;this._passParameters.normalTexture=r,this._passParameters.depthTexture=o,this._passParameters.projScale=1/m.computeScreenPixelSizeAtDist(1),this._passParameters.intensity=4*D/(0,p.g)(m)**6*x;const y=m.fullViewport[2],w=m.fullViewport[3],M=this.fboCache.acquire(y,w,"ssao input",2);s.bindFramebuffer(M.fbo),s.setViewport(0,0,y,w),s.bindTechnique(a,d,this._passParameters,this._drawParameters),s.screen.draw();const S=Math.round(y/2),T=Math.round(w/2),C=this.fboCache.acquire(S,T,"ssao blur",0);s.bindFramebuffer(C.fbo),this._drawParameters.colorTexture=M.getTexture(),(0,u.hZ)(this._drawParameters.blurSize,0,2/w),s.bindTechnique(i,d,this._passParameters,this._drawParameters),s.setViewport(0,0,S,T),s.screen.draw(),M.release();const _=this.fboCache.acquire(S,T,h.OG.AMBIENT_ILLUMINATION,0);return s.bindFramebuffer(_.fbo),s.setViewport(0,0,y,w),s.setClearColor(1,1,1,0),s.clear(16384),this._drawParameters.colorTexture=C.getTexture(),(0,u.hZ)(this._drawParameters.blurSize,2/y,0),s.bindTechnique(i,d,this._passParameters,this._drawParameters),s.setViewport(0,0,S,T),s.screen.draw(),s.setViewport4fv(m.fullViewport),C.release(),g<1&&this.requestRender(2),_}};(0,i.Cg)([(0,d.MZ)()],z.prototype,"consumes",void 0),(0,i.Cg)([(0,d.MZ)()],z.prototype,"produces",void 0),z=(0,i.Cg)([(0,d.$K)("esri.views.3d.webgl-engine.effects.ssao.SSAO")],z);const D=.5;function F(e,t){t.receiveAmbientOcclusion?(e.uniforms.add(new a.x("ssaoTex",e=>e.ssao?.getTexture())),e.constants.add("blurSizePixelsInverse","float",.5),e.code.add(o.H`float evaluateAmbientOcclusionInverse() {
vec2 ssaoTextureSizeInverse = 1.0 / vec2(textureSize(ssaoTex, 0));
return texture(ssaoTex, gl_FragCoord.xy * blurSizePixelsInverse * ssaoTextureSizeInverse).r;
}
float evaluateAmbientOcclusion() {
return 1.0 - evaluateAmbientOcclusionInverse();
}`)):e.code.add(o.H`float evaluateAmbientOcclusionInverse() { return 1.0; }
float evaluateAmbientOcclusion() { return 0.0; }`)}},15850(e,t,r){r.d(t,{kA:()=>N,a8:()=>W,eU:()=>E});var o=r(29162);class a extends o.n{constructor(e,t,r,o){super(e,"float",0,(t,a)=>t.setUniform1fv(e,r(a),o),t)}}var i=r(62462);function n(e,t){e.uniforms.add(new a("shR",9,({lighting:e})=>e.sh.r),new a("shG",9,({lighting:e})=>e.sh.g),new a("shB",9,({lighting:e})=>e.sh.b)),e.code.add(i.H`vec3 calculateAmbientIrradiance(vec3 normal) {
vec3 ambientLight = 0.282095 * vec3(shR[0], shG[0], shB[0]);
vec4 sh1 = vec4(
0.488603 * normal.x,
0.488603 * normal.z,
0.488603 * normal.y,
1.092548 * normal.x * normal.y
);
vec4 sh2 = vec4(
1.092548 * normal.y * normal.z,
0.315392 * (3.0 * normal.z * normal.z - 1.0),
1.092548 * normal.x * normal.z,
0.546274 * (normal.x * normal.x - normal.y * normal.y)
);
vec4 lightingAmbientSH_R1 = vec4(shR[1], shR[2], shR[3], shR[4]);
vec4 lightingAmbientSH_G1 = vec4(shG[1], shG[2], shG[3], shG[4]);
vec4 lightingAmbientSH_B1 = vec4(shB[1], shB[2], shB[3], shB[4]);
ambientLight += vec3(
dot(lightingAmbientSH_R1, sh1),
dot(lightingAmbientSH_G1, sh1),
dot(lightingAmbientSH_B1, sh1)
);
vec4 lightingAmbientSH_R2 = vec4(shR[5], shR[6], shR[7], shR[8]);
vec4 lightingAmbientSH_G2 = vec4(shG[5], shG[6], shG[7], shG[8]);
vec4 lightingAmbientSH_B2 = vec4(shB[5], shB[6], shB[7], shB[8]);
ambientLight += vec3(
dot(lightingAmbientSH_R2, sh2),
dot(lightingAmbientSH_G2, sh2),
dot(lightingAmbientSH_B2, sh2)
);
return ambientLight;
}`),1!==t.pbrMode&&2!==t.pbrMode||e.code.add(i.H`const vec3 skyTransmittance = vec3(0.9, 0.9, 1.0);
vec3 calculateAmbientRadiance()
{
vec3 ambientLight = 1.2 * (0.282095 * vec3(shR[0], shG[0], shB[0])) - 0.2;
return ambientLight *= skyTransmittance;
}`)}var s=r(87646),l=r(56926),c=r(40574),d=r(75762),u=r(48425),h=r(70483),m=r(96384),p=r(31635),f=r(57725),v=r(61985),g=r(69636),x=r(53334),b=r(14298),y=r(90238),w=r(22950),M=r(37809),S=r(70051),T=r(73218),C=r(15651);let I=class extends T.w{constructor(){super(...arguments),this.shader=new S.r(M.a,()=>r.e(3044).then(r.bind(r,83044)))}initializePipeline(){return(0,C.Ey)({colorWrite:C.kn})}};I=(0,p.Cg)([(0,g.$K)("esri.views.3d.webgl-engine.effects.globalIllumination.GlobalIlluminationBlurTechnique")],I);let _=class extends T.w{constructor(){super(...arguments),this.shader=new S.r(w.a,()=>r.e(4699).then(r.bind(r,54699)))}initializePipeline(){return(0,C.Ey)({colorWrite:C.kn})}};_=(0,p.Cg)([(0,g.$K)("esri.views.3d.webgl-engine.effects.globalIllumination.GlobalIlluminationTechnique")],_);var P=r(67069);class z extends P.K{constructor(){super(...arguments),this.hasColor=!0,this.hasEmission=!1,this.rayMarchMaxReach=.5,this.rayMarchMaxSteps=16,this.useProjectedRayLength=!0,this.clampRayToScreen=!1}}(0,p.Cg)([(0,P.W)()],z.prototype,"hasColor",void 0),(0,p.Cg)([(0,P.W)()],z.prototype,"hasEmission",void 0);var D=r(27351);let F=class extends T.w{constructor(){super(...arguments),this.shader=new S.r(D.a,()=>r.e(7824).then(r.bind(r,47824)))}initializePipeline(){return(0,C.Ey)({colorWrite:C.kn})}};F=(0,p.Cg)([(0,g.$K)("esri.views.3d.webgl-engine.effects.globalIllumination.GlobalIlluminationUpscaleTechnique")],F),r(68716);let R=class extends y.A{constructor(e){super(e),this.consumes={required:["normals"]},this.produces=b.OG.AMBIENT_ILLUMINATION,this._passParameters=new w.G,this._drawParameters=new M.G,this._drawParametersUpscale=new D.G,this._maxFrames=256,this._lowQualityResolutionScale=.25,this._configuration=new z,this._globalIllumination=null,this._isGlobalIlluminationUpdate=!1,this._resetBuffer=!1}initialize(){this.addHandles((0,v.wB)(()=>this.view.stage.renderer.hasGlobalIllumination,()=>{this._resetAccumulatedFrames(),this._requestRender()},v.pc))}destroy(){this._globalIllumination=(0,f.Gz)(this._globalIllumination)}resetAccumulatedFrames(){this._isGlobalIlluminationUpdate||this._resetAccumulatedFrames()}render(e){if(this._passParameters.accumulatedFrames>=this._maxFrames)return this._globalIllumination?.retain(),this._globalIllumination;const t=e.find(({name:e})=>"normals"===e),r=t?.getTexture(),o=t?.getTexture(33306),a=this._mode;if(!r||!o)return this._emptyOutput;if(0===a)return this._resetBuffer=!1,this._emptyOutput;if(!this._canRender)return this._resetBuffer=!1,this._requestRender(),this._emptyOutput;const i=this.bindParameters;this._configuration.hasEmission=!!i.reprojection.lastFrameEmission;const n=this.techniques.getCompiled(_,this._configuration),s=this.techniques.getCompiled(I),l=1===a,c=l?this._lowQualityResolutionScale:1,d=l?this.techniques.getCompiled(F):null;if(!n||!s||l&&!d)return this._requestRender(),this._emptyOutput;const u=this.renderingContext,{camera:h}=i;this._passParameters.normalTexture=r,this._passParameters.depthTexture=o,this._passParameters.projScale=1/h.computeScreenPixelSizeAtDist(1),this._passParameters.scaleGlobalIllumination=c;const{fullWidth:m,fullHeight:p}=h,f=Math.max(1,Math.floor(m*c)),v=Math.max(1,Math.floor(p*c)),g=this.fboCache.acquire(f,v,"global illumination input").acquireColor(36065,0);u.bindFramebuffer(g.fbo),u.setViewport(0,0,f,v),u.bindTechnique(n,i,this._passParameters,this._drawParameters),u.screen.draw();const y=g.obtainAttachment(36065),w=Math.max(1,Math.round(f/1)),M=Math.max(1,Math.round(v/1)),S=this.fboCache.acquire(w,M,"global illumination blur horizontal");u.bindFramebuffer(S.fbo),this._drawParameters.texture=g.getTexture(),this._drawParameters.weightTexture=y.attachment,(0,x.hZ)(this._drawParameters.blurSize,0,1/v),u.bindTechnique(s,i,this._passParameters,this._drawParameters),u.setViewport(0,0,w,M),u.screen.draw(),g.release();const T=l?"global illumination blur vertical":b.OG.AMBIENT_ILLUMINATION,C=this.fboCache.acquire(w,M,T);u.bindFramebuffer(C.fbo),u.setViewport(0,0,w,M),u.setClearColor(1,1,1,0),u.clear(16384),this._drawParameters.texture=S.getTexture(),this._drawParameters.weightTexture=y.attachment,(0,x.hZ)(this._drawParameters.blurSize,1/w,0),u.bindTechnique(s,i,this._passParameters,this._drawParameters),u.setViewport(0,0,w,M),u.screen.draw(),S.release(),C.attachColor(y,36065),y.release();let P=C;return d&&(P=this.fboCache.acquire(m,p,b.OG.AMBIENT_ILLUMINATION).acquireColor(36065,0),u.bindFramebuffer(P.fbo),u.setViewport(0,0,m,p),u.setClearColor(1,1,1,0),u.clear(16384),this._drawParametersUpscale.colorTexture=C.getTexture(),this._drawParametersUpscale.weightTexture=C.getTexture(36065),u.bindTechnique(d,i,this._passParameters,this._drawParametersUpscale),u.screen.draw(),C.release()),u.setViewport4fv(h.fullViewport),this._passParameters.temporalSampleFrame=(this._passParameters.temporalSampleFrame+1)%64,++this._passParameters.accumulatedFrames,this._cacheGlobalIllumination(P),this._passParameters.accumulatedFrames<this._maxFrames&&this._requestRender(),P}_requestRender(){this._isGlobalIlluminationUpdate=!0,this.requestRender(1),this._isGlobalIlluminationUpdate=!1}_cacheGlobalIllumination(e){this._globalIllumination!==e&&(this._globalIllumination=(0,f.Gz)(this._globalIllumination),this._globalIllumination=e,this._globalIllumination.retain())}get _emptyOutput(){const e=this.renderingContext,{fullWidth:t,fullHeight:r}=this.bindParameters.camera,o=this.fboCache.acquire(t,r,b.OG.AMBIENT_ILLUMINATION).acquireColor(36065,0);return e.bindFramebuffer(o.fbo),e.setViewport(0,0,t,r),e.clearBuffer(0,[0,0,0,1]),e.clearBuffer(1,[0,0,0,0]),o}get _canRender(){const{reprojection:e,hasEmission:t,globalIllumination:r}=this.bindParameters;return!(!e.lastFrameColor||t&&!e.lastFrameEmission||!e.lastFrameDepth||!r||this._resetBuffer)}get _mode(){const{hasGlobalIlluminationHighQuality:e,hasGlobalIllumination:t}=this.view.stage.renderer;return e?2:t?1:0}_resetAccumulatedFrames(){this._passParameters.accumulatedFrames=0,this._globalIllumination=(0,f.Gz)(this._globalIllumination)}get test(){const e=this;return{passParameters:this._passParameters,configuration:this._configuration,get maxFrames(){return e._maxFrames},set maxFrames(t){e._maxFrames=t},get lowQualityResolutionScale(){return e._lowQualityResolutionScale},set lowQualityResolutionScale(t){e._lowQualityResolutionScale=t},get mode(){return e._mode},restartAccumulation:()=>{this._resetAccumulatedFrames(),this._passParameters.temporalSampleFrame=0,this._resetBuffer=!0,this._requestRender()}}}};function O(e,t){t.receiveGlobalIllumination?(e.uniforms.add(new h.o("hasGlobalIlluminationTexture",e=>null!=e.globalIllumination),new m.x("globalIlluminationTexture",e=>e.globalIllumination?.getTexture())),e.constants.add("blurSizePixelsInverse","float",1),e.code.add(i.H`vec3 readGlobalIlluminationOcclusionInverse() {
if (!hasGlobalIlluminationTexture) {
return vec3(1.0);
}
ivec2 texel = ivec2(gl_FragCoord.xy * blurSizePixelsInverse);
return vec3(texelFetch(globalIlluminationTexture, texel, 0).a);
}
vec3 readGlobalIlluminationOcclusion() {
return 1.0 - readGlobalIlluminationOcclusionInverse();
}
vec4 readGlobalIlluminationEmissionInverse() {
if (!hasGlobalIlluminationTexture) {
return vec4(1.0);
}
ivec2 texel = ivec2(gl_FragCoord.xy * blurSizePixelsInverse);
return 1.0 - vec4(texelFetch(globalIlluminationTexture, texel, 0).rgb, 0.0);
}
vec4 readGlobalIlluminationEmission() {
return max((1.0 - readGlobalIlluminationEmissionInverse() - 0.01) / 0.99, 0.0);
}`)):e.code.add(i.H`vec3 readGlobalIlluminationOcclusionInverse() { return vec3(1.0); }
vec3 readGlobalIlluminationOcclusion() { return vec3(0.0); }
vec4 readGlobalIlluminationEmissionInverse() { return vec4(1.0); }
vec4 readGlobalIlluminationEmission() { return vec4(0.0); }`)}(0,p.Cg)([(0,g.MZ)()],R.prototype,"consumes",void 0),(0,p.Cg)([(0,g.MZ)()],R.prototype,"produces",void 0),R=(0,p.Cg)([(0,g.$K)("esri.views.3d.webgl-engine.effects.globalIllumination.GlobalIllumination")],R);var j=r(41281);function B(e){e.code.add(i.H`float mapChannel(float x, vec2 p) {
if((x < p.x) && (p.x == 0.0) || !(x < p.x) && (p.x == 1.0)) {
return 0.0;
}
float result = (x < p.x) ? mix(0.0, p.y, x/p.x) : mix(p.y, 1.0, (x - p.x) / (1.0 - p.x) );
return max(result, 0.0);
}`),e.code.add(i.H`vec3 blackLevelSoftCompression(vec3 color, float averageAmbientRadiance) {
vec2 p = vec2(0.02, 0.0075) * averageAmbientRadiance;
return vec3(mapChannel(color.x, p), mapChannel(color.y, p), mapChannel(color.z, p));
}`)}function H(e){e.code.add(i.H`vec3 tonemapACES(vec3 x) {
return clamp((x * (2.51 * x + 0.03)) / (x * (2.43 * x + 0.59) + 0.14), 0.0, 1.0);
}`),e.code.add(i.H`vec3 tonemapKhronosNeutral(vec3 color) {
const float startCompression = 0.76;
const float desaturation = 0.15;
float peak = max(color.r, max(color.g, color.b));
if (peak < startCompression) {
return color;
}
float d = 1.0 - startCompression;
float newPeak = 1.0 - d * d / (peak + d - startCompression);
color *= newPeak / peak;
float g = 1.0 - 1.0 / (desaturation * (peak - newPeak) + 1.0 );
return mix(color, vec3(newPeak), g);
}`)}function W(e){e.constants.add("ambientBoostFactor","float",.4)}function E(e){e.uniforms.add(new j.U("lightingGlobalFactor",e=>e.lighting.globalFactor))}function N(e,t){const{pbrMode:r,spherical:o,hasColorTexture:a,receiveGlobalIllumination:m}=t;e.include(l.C),e.include(O,t),e.include(s.n,t),0!==r&&e.include(d.c,t),e.include(n,t),e.include(u.p),e.include(H,t);const p=!(2===r&&!a);p&&e.include(B),W(e),E(e),(0,c.Gc)(e),e.code.add(i.H`
    float additionalDirectedAmbientLight(float lightAlignment) {
      return smoothstep(0.0, 1.0, clamp(lightAlignment * 2.5, 0.0, 1.0));
    }

    float additionalDirectedAmbientLight(vec3 vPosWorld) {
      float lightAlignment = dot(${o?i.H`normalize(vPosWorld)`:i.H`vec3(0.0, 0.0, 1.0)`}, mainLightDirection);
      return smoothstep(0.0, 1.0, clamp(lightAlignment * 2.5, 0.0, 1.0));
    }
  `),(0,c.O4)(e),e.code.add(i.H`vec3 evaluateAdditionalLighting(float ambientOcclusion, vec3 vPosWorld) {
float additionalAmbientScale = additionalDirectedAmbientLight(vPosWorld);
return (1.0 - ambientOcclusion) * additionalAmbientScale * ambientBoostFactor * lightingGlobalFactor * mainLightIntensity;
}`);const f=m?"globalIlluminationOcclusion":"ssao",v=m?.75:1,g=m?1.5:1;switch(r){case 0:case 4:case 3:e.include(c.Vt),e.code.add(i.H`vec3 evaluateSceneLighting(vec3 normalWorld, vec3 albedo, float shadow, float ssao, vec3 additionalLight) {
vec3 mainLighting = applyShading(normalWorld, shadow);
vec3 ambientLighting = calculateAmbientIrradiance(normalWorld) * (1.0 - ssao);
vec3 albedoLinear = linearizeGamma(albedo);
vec3 totalLight = mainLighting + ambientLighting + additionalLight;
totalLight = min(totalLight, vec3(PI));
vec3 outColor = vec3((albedoLinear / PI) * totalLight);
return delinearizeGamma(outColor);
}`);break;case 1:case 2:{const r=m?.35:.2;e.code.add(i.H`
        const float fillLightIntensity = 0.25;
        const float horizonLightDiffusion = 0.4;
        const float additionalAmbientIrradianceFactor = 0.02;
        const float groundReflectance = ${i.H.float(r)};

        vec3 evaluateSceneLightingPBR(vec3 normal, vec3 albedo, float shadow, float ssao, vec3 additionalLight,
                                      vec3 viewDirection, vec3 upDirection, vec3 mrr, float additionalAmbientIrradiance) {
          PBRShadingInfo inputs;
          calculatePBRInputs(inputs, normal, viewDirection, upDirection, albedo, mrr);

          ${(0,i.If)(m,i.H`vec3 globalIlluminationOcclusion = min(1.2 * readGlobalIlluminationOcclusion(), 1.0);`)}
      `),t.useFillLights?e.uniforms.add(new h.o("hasFillLights",e=>e.enableFillLights)):e.constants.add("hasFillLights","bool",!1),e.code.add(i.H`
        vec3 ambientDir = vec3(5.0 * upDirection[1] - upDirection[0] * upDirection[2], - 5.0 * upDirection[0] - upDirection[2] * upDirection[1], upDirection[1] * upDirection[1] + upDirection[0] * upDirection[0]);
        ambientDir = ambientDir != vec3(0.0) ? normalize(ambientDir) : normalize(vec3(5.0, -1.0, 0.0));

        inputs.NdotAmbDir = hasFillLights ? abs(dot(normal, ambientDir)) : 1.0;

        // Calculate the irradiance components: sun, fill lights and the sky.
        vec3 mainLightIrradianceComponent = ${i.H.float(v)} * inputs.NdotL * (1.0 - shadow) * mainLightIntensity;
        vec3 fillLightsIrradianceComponent = inputs.NdotAmbDir * mainLightIntensity * fillLightIntensity;
        // calculate ambient irradiance for localView and additionalLight for globalView
        vec3 ambientLightIrradianceComponent = ${i.H.float(g)} * calculateAmbientIrradiance(normal) * (1.0 - ${f}) + additionalLight;

        // Assemble the overall irradiance of the sky that illuminates the surface
        inputs.skyIrradianceToSurface = ambientLightIrradianceComponent + mainLightIrradianceComponent + fillLightsIrradianceComponent ;
        // Assemble the overall irradiance of the ground that illuminates the surface. for this we use the simple model that changes only the sky irradiance by the groundReflectance
        inputs.groundIrradianceToSurface = groundReflectance * ambientLightIrradianceComponent + mainLightIrradianceComponent + fillLightsIrradianceComponent ;
      `),e.uniforms.add(new j.U("lightingSpecularStrength",e=>e.lighting.mainLight.specularStrength),new j.U("lightingEnvironmentStrength",e=>e.lighting.mainLight.environmentStrength)).code.add(i.H`
        vec3 horizonRingDir = inputs.RdotUP * upDirection - inputs.reflectedView;
        vec3 horizonRingH = normalize(horizonRingDir - viewDirection);
        inputs.NdotH_Horizon = dot(normal, horizonRingH);

        vec3 mainLightRadianceComponent = lightingSpecularStrength * normalDistribution(inputs.NdotH, inputs.roughness) * mainLightIntensity * (1.0 - shadow);
        vec3 horizonLightRadianceComponent = lightingEnvironmentStrength * normalDistribution(inputs.NdotH_Horizon, min(inputs.roughness + horizonLightDiffusion, 1.0)) * mainLightIntensity * fillLightIntensity;

        // calculateAmbientRadiance for localView and additionalLight for global view
        vec3 ambientLightRadianceComponent = lightingEnvironmentStrength * calculateAmbientRadiance() * (1.0 - ${f}) + additionalLight;
        float normalDirectionModifier = mix(1., min(mix(0.1, 2.0, (inputs.NdotUP + 1.) * 0.5), 1.0), clamp(inputs.roughness * 5.0, 0.0 , 1.0));

        // Assemble the overall radiance of the sky that illuminates the surface
        inputs.skyRadianceToSurface = (ambientLightRadianceComponent + horizonLightRadianceComponent) * normalDirectionModifier + mainLightRadianceComponent;

        // Assemble the overall radiance of the ground that illuminates the surface. for this we use the simple model that changes only the sky radiance by the groundReflectance
        inputs.groundRadianceToSurface = 0.5 * groundReflectance * (ambientLightRadianceComponent + horizonLightRadianceComponent) * normalDirectionModifier + mainLightRadianceComponent;

        // Calculate average ambient radiance - This is used in the gamut mapping process to determine the black level for compression
        inputs.averageAmbientRadiance = ambientLightIrradianceComponent[1] * (1.0 + groundReflectance);
      `),e.code.add(i.H`
        vec3 reflectedColorComponent = evaluateEnvironmentIllumination(inputs);
        vec3 additionalMaterialReflectanceComponent = inputs.albedoLinear * additionalAmbientIrradiance;
        vec3 outColorLinear = reflectedColorComponent + additionalMaterialReflectanceComponent;

        ${(0,i.If)(m,i.H`
        vec3 globalIlluminationEmission = 2.25 * (0.75 * inputs.albedoLinear + 0.25) * readGlobalIlluminationEmission().rgb;
        outColorLinear += globalIlluminationEmission;`)}

      ${p?i.H`vec3 adjustedOutColorLinear = blackLevelSoftCompression(outColorLinear, inputs.averageAmbientRadiance);`:i.H`vec3 adjustedOutColorLinear = max(vec3(0.0), outColorLinear - 0.005 * inputs.averageAmbientRadiance);`}

        return delinearizeGamma(adjustedOutColorLinear);
      }
    `);break}case 5:case 6:{const t=m?.35:.5,r=m?.75:1,o=m?1.5:1;(0,c.Gc)(e),(0,c.O4)(e),e.code.add(i.H`
      const float roughnessTerrain = 0.5;
      const float specularityTerrain = ${i.H.float(t)};

      vec3 evaluatePBRSimplifiedLighting(vec3 normal, vec3 albedo, float shadow, float ssao, vec3 additionalLight, vec3 viewDirection, vec3 upDirection) {
        PBRShadingInfo inputs;
        calculateSimplifiedInputs(inputs, normal, viewDirection, upDirection, albedo);

        ${(0,i.If)(m,i.H`vec3 globalIlluminationOcclusion = min(1.2 * readGlobalIlluminationOcclusion(), 1.0);`)}

        vec3 mainLightIrradianceComponent = ${i.H.float(r)} * (1.0 - shadow) * inputs.NdotL * mainLightIntensity;
        vec3 ambientLightIrradianceComponent = ${i.H.float(o)} * calculateAmbientIrradiance(normal) * (1.0 - ${f}) + additionalLight;
        vec3 ambientSky = ambientLightIrradianceComponent + mainLightIrradianceComponent;

        vec3 indirectDiffuse = ((1.0 - inputs.NdotUP) * mainLightIrradianceComponent + (1.0 + inputs.NdotUP ) * ambientSky) * 0.5;
        vec3 outDiffColor = inputs.albedoLinear * (1.0 - inputs.f0) * indirectDiffuse / PI;

        vec3 mainLightRadianceComponent = normalDistribution(inputs.NdotH, roughnessTerrain) * mainLightIntensity;
        vec2 dfg = prefilteredDFGAnalytical(roughnessTerrain, inputs.NdotV);
        vec3 specularColor = inputs.f0 * dfg.x + inputs.f90 * dfg.y;
        vec3 specularComponent = specularityTerrain * specularColor * mainLightRadianceComponent;

        vec3 outColorLinear = outDiffColor + specularComponent;

        ${(0,i.If)(m,i.H`
        vec3 globalIlluminationEmission = 2.25 * (0.75 * inputs.albedoLinear + 0.25) * readGlobalIlluminationEmission().rgb;
        outColorLinear += globalIlluminationEmission;`)}

        return delinearizeGamma(outColorLinear);
      }
      `);break}}}r(4477)},56926(e,t,r){r.d(t,{C:()=>i});var o=r(36137),a=r(62462);function i(e){e.constants.add("GAMMA","float",2.2).constants.add("INV_GAMMA","float",o.iw).code.add(a.H`vec3 delinearizeGamma(vec3 color) {
return pow(color, vec3(INV_GAMMA));
}
vec4 delinearizeGamma(vec4 color) {
return vec4(delinearizeGamma(color.rgb), color.a);
}
vec3 linearizeGamma(vec3 color) {
return pow(color, vec3(GAMMA));
}`)}},49874(e,t,r){r.d(t,{Q:()=>a});var o=r(62462);function a(e){e.fragment.code.add(o.H`
    float globalIlluminationNormalSimilarityWeight(vec3 sampleNormal, vec3 centerNormal) {
      return clamp(1.0 - ${o.H.float(15.3)} * length(sampleNormal - centerNormal), 0.0, 1.0);
    }

    float globalIlluminationDepthNormalCorrection(vec3 encodedNormal) {
      vec3 decodedNormal = normalize(encodedNormal * 2.0 - 1.0);
      return pow(max((1.0 - abs(decodedNormal.x)) * (1.0 - abs(decodedNormal.y)), 0.01), ${o.H.float(5)});
    }

    float globalIlluminationDepthSharpness(float projScale, float depth) {
      return ${o.H.float(-.05)} * projScale / depth;
    }

    float globalIlluminationDepthSharpness(float projScale, float depth, vec3 encodedNormal) {
      return globalIlluminationDepthSharpness(projScale, depth) * globalIlluminationDepthNormalCorrection(encodedNormal);
    }
  `)}},40574(e,t,r){r.d(t,{Gc:()=>i,O4:()=>n,Vt:()=>s});var o=r(9504),a=r(62462);function i(e){e.uniforms.add(new o.d("mainLightDirection",e=>e.lighting.mainLight.direction))}function n(e){e.uniforms.add(new o.d("mainLightIntensity",e=>e.lighting.mainLight.intensity))}function s(e){i(e),n(e),e.code.add(a.H`vec3 applyShading(vec3 shadingNormal, float shadow) {
float dotVal = clamp(dot(shadingNormal, mainLightDirection), 0.0, 1.0);
return mainLightIntensity * ((1.0 - shadow) * dotVal);
}`)}},23605(e,t,r){r.d(t,{r:()=>a});var o=r(62462);function a(e,t){const r=e.fragment;switch(r.code.add(o.H`struct ShadingNormalParameters {
vec3 normalView;
vec3 viewDirection;
} shadingParams;`),t.doubleSidedMode){case 0:r.code.add(o.H`vec3 shadingNormal(ShadingNormalParameters params) {
return normalize(params.normalView);
}`);break;case 1:r.code.add(o.H`vec3 shadingNormal(ShadingNormalParameters params) {
return dot(params.normalView, params.viewDirection) > 0.0 ? normalize(-params.normalView) : normalize(params.normalView);
}`);break;case 2:r.code.add(o.H`vec3 shadingNormal(ShadingNormalParameters params) {
return gl_FrontFacing ? normalize(params.normalView) : normalize(-params.normalView);
}`);break;default:t.doubleSidedMode;case 3:}}},75762(e,t,r){r.d(t,{c:()=>s});var o=r(62462);function a(e){e.code.add(o.H`vec3 evaluateDiffuseIlluminationHemisphere(vec3 ambientGround, vec3 ambientSky, float NdotNG) {
return ((1.0 - NdotNG) * ambientGround + (1.0 + NdotNG) * ambientSky) * 0.5;
}`),e.code.add(o.H`float integratedRadiance(float cosTheta2, float roughness) {
return (cosTheta2 - 1.0) / (cosTheta2 * (1.0 - roughness * roughness) - 1.0);
}`),e.code.add(o.H`vec3 evaluateSpecularIlluminationHemisphere(vec3 ambientGround, vec3 ambientSky, float RdotNG, float roughness) {
float cosTheta2 = 1.0 - RdotNG * RdotNG;
float intRadTheta = integratedRadiance(cosTheta2, roughness);
float ground = RdotNG < 0.0 ? 1.0 - intRadTheta : 1.0 + intRadTheta;
float sky = 2.0 - ground;
return (ground * ambientGround + sky * ambientSky) * 0.5;
}`)}var i=r(56926),n=r(48425);function s(e,t){e.include(i.C),e.include(n.p),1!==t.pbrMode&&2!==t.pbrMode&&5!==t.pbrMode&&6!==t.pbrMode||(e.code.add(o.H`float normalDistribution(float NdotH, float roughness)
{
float a = NdotH * roughness;
float b = roughness / (1.0 - NdotH * NdotH + a * a);
return b * b * INV_PI;
}`),e.code.add(o.H`const vec4 c0 = vec4(-1.0, -0.0275, -0.572,  0.022);
const vec4 c1 = vec4( 1.0,  0.0425,  1.040, -0.040);
const vec2 c2 = vec2(-1.04, 1.04);
vec2 prefilteredDFGAnalytical(float roughness, float NdotV) {
vec4 r = roughness * c0 + c1;
float a004 = min(r.x * r.x, exp2(-9.28 * NdotV)) * r.x + r.y;
return c2 * a004 + r.zw;
}`),e.code.add(o.H`struct PBRShadingInfo
{
float NdotV;
float NdotL;
float LdotH;
float NdotUP;
float RdotUP;
float NdotAmbDir;
float NdotH_Horizon;
float NdotH;
vec3 skyRadianceToSurface;
vec3 groundRadianceToSurface;
vec3 skyIrradianceToSurface;
vec3 groundIrradianceToSurface;
vec3 reflectedView;
float averageAmbientRadiance;
vec3 albedoLinear;
vec3 f0;
vec3 f90;
vec3 diffuseColor;
float metalness;
float roughness;
};`),e.code.add(o.H`void calculateCommonInputs(out PBRShadingInfo inputs, vec3 normal, vec3 viewDirection, vec3 upDirection, vec3 albedo) {
vec3 h = normalize(mainLightDirection - viewDirection);
inputs.NdotV = clamp(abs(dot(normal, -viewDirection)), 0.001, 1.0);
inputs.NdotUP = clamp(dot(normal, upDirection), -1.0, 1.0);
inputs.reflectedView = normalize(reflect(-viewDirection, normal));
inputs.RdotUP = clamp(dot(inputs.reflectedView, upDirection), -1.0, 1.0);
inputs.albedoLinear = linearizeGamma(albedo);
inputs.NdotH = clamp(dot(normal, h), 0.0, 1.0);
inputs.NdotL = clamp(dot(normal, mainLightDirection), 0.001, 1.0);
}`)),1!==t.pbrMode&&2!==t.pbrMode||(e.include(a),e.code.add(o.H`vec3 evaluateEnvironmentIllumination(PBRShadingInfo inputs) {
vec3 indirectDiffuse = evaluateDiffuseIlluminationHemisphere(inputs.groundIrradianceToSurface, inputs.skyIrradianceToSurface, inputs.NdotUP);
vec3 indirectSpecular = evaluateSpecularIlluminationHemisphere(inputs.groundRadianceToSurface, inputs.skyRadianceToSurface, inputs.RdotUP, inputs.roughness);
vec3 diffuseComponent = inputs.diffuseColor * indirectDiffuse * INV_PI;
vec2 dfg = prefilteredDFGAnalytical(inputs.roughness, inputs.NdotV);
vec3 specularColor = inputs.f0 * dfg.x + inputs.f90 * dfg.y;
vec3 specularComponent = specularColor * indirectSpecular;
return (diffuseComponent + specularComponent);
}`),e.code.add(o.H`void calculatePBRInputs(out PBRShadingInfo inputs, vec3 normal, vec3 viewDirection, vec3 upDirection, vec3 albedo, vec3 mrr) {
calculateCommonInputs(inputs, normal, viewDirection, upDirection, albedo);
inputs.metalness = mrr[0];
inputs.roughness = clamp(mrr[1] * mrr[1], 0.001, 0.99);
inputs.f0 = (0.16 * mrr[2] * mrr[2]) * (1.0 - inputs.metalness) + inputs.albedoLinear * inputs.metalness;
inputs.f90 = vec3(clamp(dot(inputs.f0, vec3(50.0 * 0.33)), 0.0, 1.0));
inputs.diffuseColor = inputs.albedoLinear * (vec3(1.0) - inputs.f0) * (1.0 - inputs.metalness);
}`)),5!==t.pbrMode&&6!==t.pbrMode||e.code.add(o.H`const vec3 fresnelReflectionSimplified = vec3(0.04);
void calculateSimplifiedInputs(out PBRShadingInfo inputs, vec3 normal, vec3 viewDirection, vec3 upDirection, vec3 albedo) {
calculateCommonInputs(inputs, normal, viewDirection, upDirection, albedo);
float lightness = 0.3 * inputs.albedoLinear[0] + 0.5 * inputs.albedoLinear[1] + 0.2 * inputs.albedoLinear[2];
inputs.f0 = (0.85 * lightness + 0.15) * fresnelReflectionSimplified;
inputs.f90 =  vec3(clamp(dot(inputs.f0, vec3(50.0 * 0.33)), 0.0, 1.0));
}`)}},35212(e,t,r){r.d(t,{_:()=>c});var o=r(2169),a=r(223),i=r(64802),n=r(62462),s=r(29247),l=r(19778);function c(e,t){const r=t.pbrMode,c=e.fragment;if(2!==r&&0!==r&&1!==r)return void c.code.add(n.H`void applyPBRFactors() {}`);if(0===r)return void c.code.add(n.H`void applyPBRFactors() {}
float getBakedOcclusion() { return 1.0; }`);if(2===r)return void c.code.add(n.H`vec3 mrr = vec3(0.0, 0.6, 0.2);
float occlusion = 1.0;
void applyPBRFactors() {}
float getBakedOcclusion() { return 1.0; }`);const{hasMetallicRoughnessTexture:d,hasMetallicRoughnessTextureTransform:u,hasOcclusionTexture:h,hasOcclusionTextureTransform:m,bindType:p}=t;(d||h)&&e.include(o.r,t),c.code.add(n.H`vec3 mrr;
float occlusion;`),d&&c.uniforms.add(1===p?new l.N("texMetallicRoughness",e=>e.textureMetallicRoughness):new s.o("texMetallicRoughness",e=>e.textureMetallicRoughness)),h&&c.uniforms.add(1===p?new l.N("texOcclusion",e=>e.textureOcclusion):new s.o("texOcclusion",e=>e.textureOcclusion)),c.uniforms.add(1===p?new i.t("mrrFactors",e=>e.mrrFactors):new a.W("mrrFactors",e=>e.mrrFactors)),c.code.add(n.H`
    ${(0,n.If)(d,n.H`void applyMetallicRoughness(vec2 uv) {
            vec3 metallicRoughness = textureLookup(texMetallicRoughness, uv).rgb;
            mrr[0] *= metallicRoughness.b;
            mrr[1] *= metallicRoughness.g;
          }`)}

    ${(0,n.If)(h,"void applyOcclusion(vec2 uv) { occlusion *= textureLookup(texOcclusion, uv).r; }")}

    float getBakedOcclusion() {
      return ${h?"occlusion":"1.0"};
    }

    void applyPBRFactors() {
      mrr = mrrFactors;
      occlusion = 1.0;

      ${(0,n.If)(d,`applyMetallicRoughness(${u?"metallicRoughnessUV":"vuv0"});`)}
      ${(0,n.If)(h,`applyOcclusion(${m?"occlusionUV":"vuv0"});`)}
    }
  `)}(r(40327),r(13439)).Y},65275(e,t,r){r.d(t,{LA:()=>M,QH:()=>w}),r(19913);var o=r(47635),a=r(77788),i=r(62462);function n(e,t){const r=(0,a._o)(t.output)&&t.receiveShadows;r&&(0,o.o)(e,!0),e.vertex.code.add(i.H`
    void forwardLinearDepthToReadShadowMap() { ${(0,i.If)(r,"forwardLinearDepth(gl_Position.w);")} }
  `)}var s=r(70751),l=r(43809),c=r(29162);class d extends c.n{constructor(e,t,r,o){super(e,"mat4",2,(r,a,i,n)=>r.setUniformMatrices4fv(e,t(a,i,n),o),r)}}class u extends c.n{constructor(e,t,r,o){super(e,"mat4",1,(r,a,i)=>r.setUniformMatrices4fv(e,t(a,i),o),r)}}var h=r(13439);function m(e){e.uniforms.add(new u("shadowMapMatrix",(e,t)=>t.shadowMap.getShadowMapMatrices(e.origin),4)),e.include(f)}function p(e){e.uniforms.add(new d("shadowMapMatrix",(e,t)=>t.shadowMap.getShadowMapMatrices(e.origin),4)),e.include(f)}function f(e){e.uniforms.add(new s.I("cascadeDistances",e=>e.shadowMap.cascadeDistances),new l.W("numCascades",e=>e.shadowMap.numCascades)),e.code.add(v)}h.Y;const v=i.H`const vec3 invalidShadowmapUVZ = vec3(0.0, 0.0, -1.0);
vec3 lightSpacePosition(vec3 _vpos, mat4 mat) {
vec4 lv = mat * vec4(_vpos, 1.0);
lv.xy /= lv.w;
return 0.5 * lv.xyz + vec3(0.5);
}
vec2 cascadeCoordinates(int i, ivec2 textureSize, vec3 lvpos) {
float xScale = float(textureSize.y) / float(textureSize.x);
return vec2((float(i) + lvpos.x) * xScale, lvpos.y);
}
vec3 calculateUVZShadow(in vec3 _worldPos, in float _linearDepth, in ivec2 shadowMapSize) {
int i = _linearDepth < cascadeDistances[1] ? 0 : _linearDepth < cascadeDistances[2] ? 1 : _linearDepth < cascadeDistances[3] ? 2 : 3;
if (i >= numCascades) {
return invalidShadowmapUVZ;
}
mat4 shadowMatrix = i == 0 ? shadowMapMatrix[0] : i == 1 ? shadowMapMatrix[1] : i == 2 ? shadowMapMatrix[2] : shadowMapMatrix[3];
vec3 lvpos = lightSpacePosition(_worldPos, shadowMatrix);
if (lvpos.z >= 1.0 || lvpos.x < 0.0 || lvpos.x > 1.0 || lvpos.y < 0.0 || lvpos.y > 1.0) {
return invalidShadowmapUVZ;
}
vec2 uvShadow = cascadeCoordinates(i, shadowMapSize, lvpos);
return vec3(uvShadow, lvpos.z);
}`;function g(e){e.code.add(i.H`float readShadowMapUVZ(vec3 uvzShadow, sampler2DShadow _shadowMap) {
return texture(_shadowMap, uvzShadow);
}`)}var x=r(41281),b=r(96384);class y extends c.n{constructor(e,t){super(e,"sampler2DShadow",0,(r,o)=>r.bindTexture(e,t(o)))}}function w(e,t){t.receiveShadows&&e.fragment.include(m),S(e,t)}function M(e,t){t.receiveShadows&&e.fragment.include(p),S(e,t)}function S(e,t){e.fragment.uniforms.add(new x.U("lightingGlobalFactor",e=>e.lighting.globalFactor));const{hasShadowHighlights:r,receiveShadows:o,spherical:a}=t;e.include(n,t),o&&function(e,t){(function(e,t){e.include(g),e.uniforms.add(T()),t&&e.uniforms.add(new b.x("shadowHighlight",({shadowHighlight:e})=>e?.getTexture())),e.code.add(i.H`
    float readShadowMaps(const in vec3 uvzShadow) {
      if (uvzShadow.z < 0.0) {
        return 0.0;
      }

      float shadow1 = readShadowMapUVZ(uvzShadow, shadowMap);
      ${(0,i.If)(t,"float shadow2 = texelFetch(shadowHighlight, ivec2(gl_FragCoord.xy), 0).r;\n         return shadow1 > shadow2 ? shadow1 : shadow2;","return shadow1;")}
    }
  `)})(e,t),function(e){e.code.add(i.H`float readShadowMap(const in vec3 _worldPos, float _linearDepth) {
vec3 uvzShadow = calculateUVZShadow(_worldPos, _linearDepth, textureSize(shadowMap, 0));
return readShadowMaps(uvzShadow);
}`)}(e)}(e.fragment,r),e.fragment.code.add(i.H`
    float readShadow(float additionalAmbientScale, vec3 vpos) {
      return ${o?"max(lightingGlobalFactor * (1.0 - additionalAmbientScale), readShadowMap(vpos, linearDepth))":(0,i.If)(a,"lightingGlobalFactor * (1.0 - additionalAmbientScale)","0.0")};
    }
  `)}function T(){return new y("shadowMap",({shadowMap:e})=>e.getOutput(5)??e.getOutput(7))}h.Y},10452(e,t,r){r.d(t,{O:()=>c});var o=r(16937),a=r(33),i=r(41281),n=r(62462),s=r(7574),l=r(96384);function c(e,t){const r=e.fragment;r.include(o.E),r.uniforms.add(new a.E("nearFar",e=>e.camera.nearFar),new l.x("depthMap",e=>e.depth?.attachment),new s.F("proj",e=>e.camera.projectionMatrix),new i.U("invResolutionHeight",e=>1/e.camera.height),new s.F("reprojectionMatrix",e=>e.reprojection.matrix)).code.add(n.H`
  vec2 reprojectionCoordinate(vec3 projectionCoordinate) {
    vec4 clipDepthCoordinate = proj * vec4(0.0, 0.0, -projectionCoordinate.z, 1.0);
    vec4 reprojectedCoordinate = reprojectionMatrix * vec4(
      clipDepthCoordinate.w * (projectionCoordinate.xy * 2.0 - 1.0),
      clipDepthCoordinate.z,
      clipDepthCoordinate.w
    );
    reprojectedCoordinate.xy /= reprojectedCoordinate.w;
    return reprojectedCoordinate.xy * 0.5 + 0.5;
  }

  vec4 applyProjectionMat(mat4 projectionMat, vec3 viewPosition) {
    vec4 projectedCoordinate =  projectionMat * vec4(viewPosition, 1.0);
    projectedCoordinate.xy /= projectedCoordinate.w;
    projectedCoordinate.xy = projectedCoordinate.xy*0.5 + 0.5;
    return projectedCoordinate;
  }

  float rayMarchScreenReachFromWorldReach(vec3 startPosition, vec3 rayDirection, float rayMarchWorldReach) {
    float rayDistanceWorld = max(0.0, rayMarchWorldReach);

    // Stop rays towards camera at near plane
    if (rayDirection.z > 0.0) {
      float distanceToNearPlane = (-nearFar[0] - startPosition.z) / rayDirection.z;
      rayDistanceWorld = min(rayDistanceWorld, max(0.0, distanceToNearPlane));
    }

    vec2 projectedCoordStart = applyProjectionMat(proj, startPosition).xy;
    vec2 projectedCoordEnd = applyProjectionMat(proj, startPosition + rayDirection * rayDistanceWorld).xy;
    vec2 projectedCoordOffset = projectedCoordEnd - projectedCoordStart;

    return ${t.useProjectedRayLength?"length(projectedCoordOffset)":"abs(projectedCoordOffset.y)"};
  }

  vec3 screenSpaceIntersectionWithLimits(
    vec3 rayDirection,
    vec3 startPosition,
    vec3 viewDirection,
    vec3 normal,
    float rayStepOffset,
    float rayMarchMaxReach,
    float rayMarchMaxSteps
  ) {
    vec3 viewPosition = startPosition;

    // Project the start position to the screen
    vec4 projectedCoordStart = applyProjectionMat(proj, viewPosition);
    vec3 homogeneousStart = viewPosition / projectedCoordStart.w;
    float inverseWStart = 1.0 / projectedCoordStart.w;

    // Advance the position in the ray direction
    viewPosition += rayDirection;

    vec4 projectedCoordVanishingPoint = applyProjectionMat(proj, rayDirection);

    // Project the advanced position to the screen
    vec4 projectedCoordEnd = applyProjectionMat(proj, viewPosition);
    vec3  homogeneousEnd = viewPosition / projectedCoordEnd.w;
    float inverseWEnd = 1.0 / projectedCoordEnd.w;

    // Calculate the ray direction in screen space
    vec2 projectedCoordDirection = (projectedCoordEnd.xy - projectedCoordStart.xy);
    vec2 vanishingPointScreenOffset = (projectedCoordVanishingPoint.xy - projectedCoordStart.xy);

    float rayMarchDistance = ${t.useProjectedRayLength?"length(vanishingPointScreenOffset.xy)":"abs(vanishingPointScreenOffset.y)"};
    float clampedRayMarchDistance = min(rayMarchDistance, rayMarchMaxReach);

    float projectedCoordDirectionLength = length(projectedCoordDirection);

    // normalize the projection direction depending on maximum steps
    // this determines how blocky the ray march looks
    vec2 projectedStep = clampedRayMarchDistance * projectedCoordDirection / (rayMarchMaxSteps * projectedCoordDirectionLength);

    // Normalize the homogeneous camera space coordinates
    vec3 homogeneousStep = clampedRayMarchDistance * (homogeneousEnd - homogeneousStart) / (rayMarchMaxSteps * projectedCoordDirectionLength);
    float inverseWStep = clampedRayMarchDistance * (inverseWEnd - inverseWStart) / (rayMarchMaxSteps * projectedCoordDirectionLength);

    // initialize the variables for ray marching
    vec2 projectedPosition = projectedCoordStart.xy;
    vec3 homogeneousPosition = homogeneousStart;
    float inverseW = inverseWStart;
    float rayStartZ = -startPosition.z; // estimated ray start depth value
    float rayEndZ = -startPosition.z;   // estimated ray end depth value
    float previousEstimatedZ = -startPosition.z;
    float rayDepthDelta = 0.0;
    float estimatedDepthDifference;
    float sampledDepth;

    if (dot(normal, rayDirection) < 0.0 || dot(-viewDirection, normal) < 0.0) {
      return vec3(projectedPosition, 0.0);
    }

    float previousEstimatedDepthDifference = 0.0;

    projectedPosition = clamp(
      projectedPosition + rayStepOffset * projectedStep,
      vec2(0.0),
      vec2(0.999)
    );
    homogeneousPosition.z += rayStepOffset * homogeneousStep.z;
    inverseW += rayStepOffset * inverseWStep;

    int rayMarchMaxStepsInt = int(rayMarchMaxSteps);
    for(int stepIndex = 0; stepIndex < rayMarchMaxStepsInt - 1; ++stepIndex) {
      sampledDepth = -linearDepthFromTexture(depthMap, projectedPosition); // get linear depth from the depth buffer

      // Estimate depth of the marching ray
      rayStartZ = previousEstimatedZ;
      estimatedDepthDifference = -rayStartZ - sampledDepth;
      rayEndZ = (homogeneousStep.z * 0.5 + homogeneousPosition.z) / (inverseWStep * 0.5 + inverseW);
      rayDepthDelta = rayEndZ - rayStartZ;
      previousEstimatedZ = rayEndZ;

      if(-rayEndZ > nearFar[1] || -rayEndZ < nearFar[0] || projectedPosition.y < 0.0  || projectedPosition.y > 1.0 ) {
        return vec3(projectedPosition, 0.);
      }

      // If we detect a hit - return the intersection point, two conditions:
      //  - estimatedDepthDifference > 0.0 - sampled point depth is in front of estimated depth
      //  - if difference between estimatedDepthDifference and rayDepthDelta is not too large
      //  - if difference between estimatedDepthDifference and 0.025/abs(inverseW) is not too large
      //  - if the sampled depth is not behind far plane or in front of near plane

      if(estimatedDepthDifference < 0.025 / abs(inverseW) + abs(rayDepthDelta) &&
        estimatedDepthDifference > 0.0 &&
        sampledDepth > nearFar[0] &&
        sampledDepth < nearFar[1] &&
        abs(projectedPosition.y - projectedCoordStart.y) > invResolutionHeight) {
        float hitInterpolationWeight = estimatedDepthDifference / (estimatedDepthDifference - previousEstimatedDepthDifference);
        vec2 refinedProjectedPosition = mix(projectedPosition - projectedStep, projectedPosition, 1.0 - hitInterpolationWeight);
        if (abs(refinedProjectedPosition.y - projectedCoordStart.y) > invResolutionHeight) {
          return vec3(refinedProjectedPosition, sampledDepth);
        }
        else {
          return vec3(projectedPosition, sampledDepth);
        }
      }

      ${(0,n.If)(!t.clampRayToScreen,"if (projectedPosition.x <= 0.0  || projectedPosition.x >= 1.0) {\n        return vec3(projectedPosition, 0.0);\n      }")}

      // Continue with ray marching
      projectedPosition = projectedPosition + projectedStep;
      homogeneousPosition.z += homogeneousStep.z;
      inverseW += inverseWStep;
      previousEstimatedDepthDifference = estimatedDepthDifference;

      ${(0,n.If)(t.clampRayToScreen,"projectedPosition = clamp(projectedPosition, vec2(0.0), vec2(0.999));")}
    }
    return vec3(projectedPosition, 0.0);
  }

  vec3 screenSpaceIntersection(vec3 rayDirection, vec3 startPosition, vec3 viewDirection, vec3 normal, float rayStepOffset) {
    return screenSpaceIntersectionWithLimits(
      rayDirection,
      startPosition,
      viewDirection,
      normal,
      rayStepOffset,
      ${n.H.float(t.rayMarchMaxReach)},
      ${n.H.float(t.rayMarchMaxSteps)}
    );
  }
  `)}},69563(e,t,r){r.d(t,{MU:()=>l,O1:()=>c,QM:()=>d,Sx:()=>s,q2:()=>n});var o=r(79441),a=r(62462),i=r(19835);function n(e,t){t.hasColorTextureTransform?(e.varyings.add("colorUV","vec2"),e.vertex.uniforms.add(new i.k("colorTextureTransformMatrix",e=>e.colorTextureTransformMatrix??o.zK)).code.add(a.H`void forwardColorUV(){
colorUV = (colorTextureTransformMatrix * vec3(vuv0, 1.0)).xy;
}`)):e.vertex.code.add(a.H`void forwardColorUV(){}`)}function s(e,t){t.hasNormalTextureTransform&&0!==t.textureCoordinateType?(e.varyings.add("normalUV","vec2"),e.vertex.uniforms.add(new i.k("normalTextureTransformMatrix",e=>e.normalTextureTransformMatrix??o.zK)).code.add(a.H`void forwardNormalUV(){
normalUV = (normalTextureTransformMatrix * vec3(vuv0, 1.0)).xy;
}`)):e.vertex.code.add(a.H`void forwardNormalUV(){}`)}function l(e,t){t.hasEmissionTextureTransform&&0!==t.textureCoordinateType?(e.varyings.add("emissiveUV","vec2"),e.vertex.uniforms.add(new i.k("emissiveTextureTransformMatrix",e=>e.emissiveTextureTransformMatrix??o.zK)).code.add(a.H`void forwardEmissiveUV(){
emissiveUV = (emissiveTextureTransformMatrix * vec3(vuv0, 1.0)).xy;
}`)):e.vertex.code.add(a.H`void forwardEmissiveUV(){}`)}function c(e,t){t.hasOcclusionTextureTransform&&0!==t.textureCoordinateType?(e.varyings.add("occlusionUV","vec2"),e.vertex.uniforms.add(new i.k("occlusionTextureTransformMatrix",e=>e.occlusionTextureTransformMatrix??o.zK)).code.add(a.H`void forwardOcclusionUV(){
occlusionUV = (occlusionTextureTransformMatrix * vec3(vuv0, 1.0)).xy;
}`)):e.vertex.code.add(a.H`void forwardOcclusionUV(){}`)}function d(e,t){t.hasMetallicRoughnessTextureTransform&&0!==t.textureCoordinateType?(e.varyings.add("metallicRoughnessUV","vec2"),e.vertex.uniforms.add(new i.k("metallicRoughnessTextureTransformMatrix",e=>e.metallicRoughnessTextureTransformMatrix??o.zK)).code.add(a.H`void forwardMetallicRoughnessUV(){
metallicRoughnessUV = (metallicRoughnessTextureTransformMatrix * vec3(vuv0, 1.0)).xy;
}`)):e.vertex.code.add(a.H`void forwardMetallicRoughnessUV(){}`)}},36288(e,t,r){r.d(t,{Ir:()=>d});var o=r(53334),a=r(56560),i=r(71072),n=r(76982),s=r(33),l=r(70751),c=r(62462);function d(e){e.fragment.uniforms.add(new l.I("projInfo",e=>function(e){const t=e.projectionMatrix;return 0===t[11]?(0,i.hZ)(u,2/(e.fullWidth*t[0]),2/(e.fullHeight*t[5]),(1+t[12])/t[0],(1+t[13])/t[5]):(0,i.hZ)(u,-2/(e.fullWidth*t[0]),-2/(e.fullHeight*t[5]),(1-t[8])/t[0],(1-t[9])/t[5])}(e.camera))),e.fragment.uniforms.add(new s.E("zScale",e=>0===e.camera.projectionMatrix[11]?(0,o.hZ)(h,0,1):(0,o.hZ)(h,1,0))),e.fragment.code.add(c.H`vec3 reconstructPosition(vec2 fragCoord, float depth) {
return vec3((fragCoord * projInfo.xy + projInfo.zw) * (zScale.x * depth + zScale.y), depth);
}`)}const u=(0,n.vt)(),h=(0,a.vt)()},73349(e,t,r){r.d(t,{S:()=>i}),r(20146);var o=r(19635),a=r(92703);function i(e,t){!function(e,t,r){const o=e.fragment;switch(o.code.add("void discardOrAdjustAlpha(inout vec4 color) {"),t.alphaDiscardMode){case 1:o.code.add("color.a = 1.0;");break;case 0:o.include(a.Q),o.code.add("if (color.a < alphaCutoff) discard;");break;case 3:o.uniforms.add(r).code.add("if (color.a < textureAlphaCutoff) discard;");break;case 2:o.uniforms.add(r).code.add("\n        if (color.a < textureAlphaCutoff) discard;\n        color.a = 1.0;\n      ");break;case 4:break;default:t.alphaDiscardMode}o.code.add("}")}(e,t,new o.m("textureAlphaCutoff",e=>e.textureAlphaCutoff))}},30588(e,t,r){r.d(t,{u:()=>i});var o=r(41281),a=r(62462);function i(e){e.uniforms.add(new o.U("dpDummy",()=>1)).code.add(a.H`vec3 dpAdd(vec3 hiA, vec3 loA, vec3 hiB, vec3 loB) {
vec3 hiD = hiA + hiB;
vec3 loD = loA + loB;
return  dpDummy * hiD + loD;
}`)}},70483(e,t,r){r.d(t,{o:()=>a});var o=r(29162);class a extends o.n{constructor(e,t){super(e,"bool",0,(r,o)=>r.setUniform1b(e,t(o)))}}},223(e,t,r){r.d(t,{W:()=>a});var o=r(29162);class a extends o.n{constructor(e,t,r){super(e,"vec3",2,(o,a,i,n)=>o.setUniform3fv(e,t(a,i,n),r))}}},64802(e,t,r){r.d(t,{t:()=>a});var o=r(29162);class a extends o.n{constructor(e,t,r){super(e,"vec3",1,(o,a,i)=>o.setUniform3fv(e,t(a,i),r))}}},20146(e,t,r){r.d(t,{J:()=>a});var o=r(29162);class a extends o.n{constructor(e,t,r){super(e,"float",2,(o,a,i)=>o.setUniform1f(e,t(a,i),r))}}},19635(e,t,r){r.d(t,{m:()=>a});var o=r(29162);class a extends o.n{constructor(e,t,r){super(e,"float",1,(o,a,i)=>o.setUniform1f(e,t(a,i),r))}}},29247(e,t,r){r.d(t,{o:()=>a});var o=r(29162);class a extends o.n{constructor(e,t,r){super(e,"sampler2D",2,(o,a,i)=>o.bindTexture(e,t(a,i),r?.(a,i)))}}},19778(e,t,r){r.d(t,{N:()=>a});var o=r(29162);class a extends o.n{constructor(e,t){super(e,"sampler2D",1,(r,o,a)=>r.bindTexture(e,t(o,a)))}}},62462(e,t,r){r.d(t,{If:()=>a});const o=(e,...t)=>{let r="";for(let o=0;o<t.length;o++)r+=e[o]+t[o];return r+=e[e.length-1],r};function a(e,t,r=""){return e?t:r}o.int=e=>e.toFixed(),o.uint=e=>`${Math.max(0,e).toFixed()}u`,o.hexuint=e=>`0x${Math.round(Math.max(0,e)).toString(16)}u`,o.float=e=>e.toPrecision(8),r.d(t,["H",0,o])},67069(e,t,r){r.d(t,{K:()=>s,W:()=>l});var o=r(62991),a=r(3223);class i{constructor(e){this._bits=[...e]}equals(e){return(0,a.aI)(this._bits,e.bits)}get code(){return this._code??=String.fromCharCode(...this._bits),this._code}get bits(){return this._bits}}var n=r(13439);class s extends n.Y{constructor(){super(),this._parameterBits=this._parameterBits?.map(()=>0)??[],this._parameterNames??=[]}get key(){return this._key??=new i(this._parameterBits),this._key}decode(e=this.key){const t=this._parameterBits;this._parameterBits=[...e.bits];const r=this._parameterNames.map(e=>`    ${e}: ${this[e]}`).join("\n");return this._parameterBits=t,r}}function l(e={}){return(t,r)=>{t.hasOwnProperty("_parameterNames")||Object.defineProperty(t,"_parameterNames",{value:t._parameterNames?.slice()??[],configurable:!0,writable:!0}),t.hasOwnProperty("_parameterBits")||Object.defineProperty(t,"_parameterBits",{value:t._parameterBits?.slice()??[0],configurable:!0,writable:!0}),t._parameterNames.push(r);const a=e.count||2,i=Math.ceil(Math.log2(a)),n=t._parameterBits;let s=0;for(;n[s]+i>16;)s++,s>=n.length&&n.push(0);const l=n[s],c=(1<<i)-1<<l;n[s]+=i,e.count?Object.defineProperty(t,r,{get(){return(this._parameterBits[s]&c)>>l},set(t){const a=this._parameterBits[s];if((a&c)>>l!==t){if(this._key=null,this._parameterBits[s]=a&~c|+t<<l&c,"number"!=typeof t)throw new o.A("internal:invalid-shader-configuration",`Configuration value for ${r} must be a number, got ${typeof t}`);if(null==e.count)throw new o.A("internal:invalid-shader-configuration",`Configuration value for ${r} must provide a count option`)}}}):Object.defineProperty(t,r,{get(){return!!((this._parameterBits[s]&c)>>l)},set(e){const t=this._parameterBits[s];if(!!((t&c)>>l)!==e&&(this._key=null,this._parameterBits[s]=t&~c|+e<<l,"boolean"!=typeof e))throw new o.A("internal:invalid-shader-configurationx",`Configuration value for ${r} must be boolean, got ${typeof e}`)}})}}},60577(e,t,r){r.d(t,{R:()=>a});var o=r(62462);function a(e){e.code.add(o.H`
    vec3 quantizeGlobalIlluminationColor(vec3 color) {
      vec3 clampedColor = clamp(color, vec3(0.0), vec3(1.0));
      return floor(clampedColor * ${o.H.float(255)} + 0.5) * ${o.H.float(1/255)};
    }
  `)}},57777(e,t,r){r.d(t,{b:()=>i});var o=r(41281),a=r(62462);function i(e,t){t.snowCover&&(e.uniforms.add(new o.U("snowCover",e=>e.snowCover)).code.add(a.H`float getSnow(vec3 normal, vec3 groundNormal) {
return smoothstep(0.5, 0.55, dot(normal, groundNormal)) * snowCover;
}
float getRealisticTreeSnow(vec3 faceNormal, vec3 shadingNormal, vec3 groundNormal) {
float snow = min(1.0, smoothstep(0.5, 0.55, dot(faceNormal, groundNormal)) +
smoothstep(0.5, 0.55, dot(-faceNormal, groundNormal)) +
smoothstep(0.0, 0.1, dot(shadingNormal, groundNormal)));
return snow * snowCover;
}`),e.code.add(a.H`vec3 applySnowToMRR(vec3 mrr, float snow) {
return mix(mrr, vec3(0.0, 1.0, 0.04), snow);
}`))}},40327(e,t,r){r.d(t,{Jr:()=>i});var o=r(71573),a=r(19913);function i({normalTexture:e,metallicRoughnessTexture:t,metallicFactor:r,roughnessFactor:i,emissiveTexture:n,emissiveFactor:s,occlusionTexture:l}){return null==e&&null==t&&null==n&&(null==s||(0,o.t2)(s,a.uY))&&null==l&&(null==i||1===i)&&(null==r||1===r)}const n=(0,a.CN)(1,1,.5),s=(0,a.CN)(0,.6,.2),l=(0,a.CN)(0,1,.2);r.d(t,["Bt",0,s,"SY",0,l,"mb",0,n])},41414(e,t,r){r.d(t,{Hp:()=>n,Tt:()=>i});var o=r(31635),a=r(67069);class i extends a.K{constructor(){super(...arguments),this.useFloatBlend=!0}}function n(e,t){t.useFloatBlend?(e.constants.add("floatBlendOutputScale","float",1),e.constants.add("floatBlendInputScale","float",1)):(e.constants.add("floatBlendOutputScale","float",1/16),e.constants.add("floatBlendInputScale","float",16)),e.constants.add("maxEmissiveStrength","float",16)}(0,o.Cg)([(0,a.W)()],i.prototype,"useFloatBlend",void 0)},13439(e,t,r){const o=class{};new o,r.d(t,["Y",0,o])},29162(e,t,r){r.d(t,{n:()=>o});class o{constructor(e,t,r,o,a=null){if(this.name=e,this.type=t,this.arraySize=a,this.bind={0:null,1:null,2:null},o)switch(r){case void 0:break;case 0:this.bind[0]=o;break;case 1:this.bind[1]=o;break;case 2:this.bind[2]=o}}equals(e){return this.type===e.type&&this.name===e.name&&this.arraySize===e.arraySize}}}}]);