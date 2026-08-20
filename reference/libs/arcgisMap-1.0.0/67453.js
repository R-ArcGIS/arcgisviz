"use strict";(self.webpackChunk=self.webpackChunk||[]).push([[67453],{46348(e,t,i){i.d(t,{b:()=>T});var n=i(24615),r=i(38587),a=i(37303),o=i(77802),s=i(47913),l=i(48425),c=i(9717),d=i(83660),p=i(33560),h=i(21586),f=i(33),u=i(70751),m=i(92121),v=i(41281),g=i(19635),S=i(62462),x=i(7574),y=i(92703),b=i(64064),C=i(82315),D=i(43398);function T(e){const t=new D.N5,{attributes:i,varyings:T,vertex:z,fragment:P}=t,{applyMarkerOffset:w,draped:L,output:O,capType:R,stippleEnabled:W,falloffEnabled:_,roundJoins:F,wireframe:E,innerColorEnabled:A,hasAnimation:I,hasScreenSizePerspective:V,worldSizedImagePattern:H}=e;z.inputs.add("position",()=>"position"),P.include(l.p),t.include(a.s,e),t.include(o.q,e),t.include(r.g,e),t.include(b.Q,e);const M=w&&!L;M&&(z.uniforms.add(new g.m("markerScale",e=>e.markerScale)),t.include(s.r,{space:2,hasScreenSizePerspective:V})),(0,h.NB)(z,e),z.uniforms.add(new x.F("inverseProjectionMatrix",e=>e.camera.inverseProjectionMatrix),new f.E("nearFar",e=>e.camera.nearFar),new g.m("miterLimit",e=>"miter"!==e.join?0:e.miterLimit),new u.I("viewport",e=>e.camera.fullViewport)),z.constants.add("LARGE_HALF_FLOAT","float",65500),z.constants.add("EPS","float",.001),z.constants.add("NUM_JOIN_SUBDIVISIONS","float",e.numJoinSubdivisions),i.add("position","vec3"),i.add("previousDelta","vec4"),i.add("nextDelta","vec4"),i.add("lineParameters","vec2"),i.add("u0","float"),T.add("vColor","vec4"),T.add("vpos","vec3",{invariant:!0}),T.add("vLineDistance","float"),T.add("vLineWidth","float"),W||(T.add("vIsInsideJoin","int"),T.add("vStretchFactor","float"),T.add("vJoinCenterLineSDFs","vec2"),T.add("vSubdivisionFactor","float"));const N=W;N&&T.add("vLineSizeInv","float");const j=2===R,k=W&&j,B=_||k;B&&T.add("vLineDistanceNorm","float"),j&&(T.add("vSegmentSDF","float"),T.add("vReverseSegmentSDF","float")),z.code.add(S.H`vec3 perpendicular(vec3 v) {
return vec3(v.y, -v.x, 0.0);
}
float interp(float ncp, vec4 a, vec4 b) {
return (-ncp - a.z) / (b.z - a.z);
}
vec3 rotateZ(vec3 v, float a) {
float s = sin(a);
float c = cos(a);
mat2 m = mat2(c, -s, s, c);
return vec3(m * v.xy, v.z);
}`),z.code.add(S.H`vec4 projectAndScale(vec4 pos) {
vec4 posNdc = proj * pos;
posNdc.xy *= viewport.zw / posNdc.w;
posNdc.z /= posNdc.w;
return posNdc;
}`),z.code.add(S.H`void clip(
inout vec4 pos,
inout vec4 prev,
inout vec4 next,
bool isStartVertex
) {
float vnp = nearFar[0] * 0.99;
if (pos.z > -nearFar[0]) {
if (!isStartVertex) {
if (prev.z < -nearFar[0]) {
pos = mix(prev, pos, interp(vnp, prev, pos));
next = pos;
} else {
pos = vec4(0.0, 0.0, 0.0, 1.0);
}
} else {
if (next.z < -nearFar[0]) {
pos = mix(pos, next, interp(vnp, pos, next));
prev = pos;
} else {
pos = vec4(0.0, 0.0, 0.0, 1.0);
}
}
} else {
if (prev.z > -nearFar[0]) {
prev = mix(pos, prev, interp(vnp, pos, prev));
}
if (next.z > -nearFar[0]) {
next = mix(next, pos, interp(vnp, next, pos));
}
}
}`),(0,h.Nz)(z),z.constants.add("aaWidth","float",W?0:1).main.add(S.H`
    // unpack values from vertex type
    bool isStartVertex = abs(abs(lineParameters.y) - 3.0) == 1.0;
    vec3 prevPosition = position + previousDelta.xyz * previousDelta.w;
    vec3 nextPosition = position + nextDelta.xyz * nextDelta.w;

    float coverage = 1.0;

    // Check for special value of lineParameters.y which is used by the Renderer when graphics are removed before the
    // VBO is recompacted. If this is the case, then we just project outside of clip space.
    if (lineParameters.y == 0.0) {
      gl_Position = ${c.Z};
    }
    else {
      vec4 pos  = view * vec4(position, 1.0);
      vec4 prev = view * vec4(prevPosition, 1.0);
      vec4 next = view * vec4(nextPosition, 1.0);

      bool isJoin = abs(lineParameters.y) < 3.0;
  `),M&&z.main.add(S.H`vec4 other = isStartVertex ? next : prev;
bool markersHidden = areWorldMarkersHidden(pos.xyz, other.xyz);
if (!isJoin && !markersHidden) {
pos.xyz += normalize(other.xyz - pos.xyz) * getWorldMarkerSize(pos.xyz) * 0.5;
}`),t.include(p.F),z.main.add(S.H`
      clip(pos, prev, next, isStartVertex);

      vec3 clippedPos = pos.xyz;
      vec3 clippedCenter = mix(pos.xyz, isStartVertex ? next.xyz : prev.xyz, 0.5);

      pos = projectAndScale(pos);
      next = projectAndScale(next);
      prev = projectAndScale(prev);

      vec3 left = (pos.xyz - prev.xyz);
      vec3 right = (next.xyz - pos.xyz);

      float leftLen = length(left);
      float rightLen = length(right);

      float lineSize = getSize(${(0,S.If)(V,"clippedPos")});
      ${(0,S.If)(W&&V,"float patternLineSize = getSize(clippedCenter);")}
      ${(0,S.If)(W&&!V,"float patternLineSize = lineSize;")}

      ${(0,S.If)(H,S.H`
          lineSize += aaWidth;
          float lineWidth = lineSize * pixelRatio * worldToScreenRatio;
          if (lineWidth < 1.0) {
            coverage = lineWidth;
            lineWidth = 1.0;
          }
        `,S.H`
          if (lineSize < 1.0) {
            coverage = lineSize; // convert sub-pixel coverage to alpha
            lineSize = 1.0;
          }

          lineSize += aaWidth;
          float lineWidth = lineSize * pixelRatio;
        `)}

      vLineWidth = noPerspectiveWrite(lineWidth, pos.w);
      ${N?S.H`vLineSizeInv = noPerspectiveWrite(1.0 / lineSize, pos.w);`:""}
  `),(W||j)&&z.main.add(S.H`
      float isEndVertex = float(!isStartVertex);
      vec3 segmentOrigin = mix(pos.xyz, prev.xyz, isEndVertex);
      vec3 segment = mix(right, left, isEndVertex);
      ${j?S.H`vec3 segmentEnd = mix(next.xyz, pos.xyz, isEndVertex);`:""}
    `),z.main.add(S.H`left = (leftLen > EPS) ? left/leftLen : vec3(0.0, 0.0, 0.0);
right = (rightLen > EPS) ? right/rightLen : vec3(0.0, 0.0, 0.0);
vec3 segmentDirection = isStartVertex ? right : left;
vec3 capDisplacementDir = vec3(0.0, 0.0, 0.0);
vec3 joinDisplacementDir = vec3(0.0, 0.0, 0.0);
float displacementLen = lineWidth;
float miterDisplacementLen = lineWidth;
float innerDisplacementLen = lineWidth;`),W||z.main.add(S.H`vIsInsideJoin = 0;
vStretchFactor = 1.0;
vSubdivisionFactor = 0.0;
vJoinCenterLineSDFs = vec2(LARGE_HALF_FLOAT);`),z.main.add(S.H`float subdivisionFactor = 0.0;
bool isOutside = false;
if (isJoin) {
isOutside = (left.x * right.y - left.y * right.x) * lineParameters.y > 0.0;
vec3 joinDirection = normalize(left + right);
joinDisplacementDir = perpendicular(joinDirection);
if (leftLen > EPS && rightLen > EPS) {
float nDotSeg = dot(joinDisplacementDir, left);
displacementLen /= length(nDotSeg * left - joinDisplacementDir);
miterDisplacementLen = displacementLen;
innerDisplacementLen = min(displacementLen, min(leftLen, rightLen)/abs(nDotSeg));
if (!isOutside) {
displacementLen = innerDisplacementLen;
}
}
subdivisionFactor = lineParameters.x;`),W||z.main.add(S.H`if(subdivisionFactor > 0.0) {
vIsInsideJoin = 1;
}
vSubdivisionFactor = isOutside ? subdivisionFactor : 0.5;
if (miterDisplacementLen > miterLimit * lineWidth) {
vec2 leftScreenDir = left.xy;
vec2 rightScreenDir = right.xy;
float leftScreenLen = length(leftScreenDir);
float rightScreenLen = length(rightScreenDir);
if (leftScreenLen > EPS && rightScreenLen > EPS) {
leftScreenDir /= leftScreenLen;
rightScreenDir /= rightScreenLen;
float theta = acos(clamp(dot(leftScreenDir, rightScreenDir), -1.0, 1.0));
float subdividedTriangleHeight = (innerDisplacementLen + lineWidth) * cos(theta / (2.0 + 2.0 * NUM_JOIN_SUBDIVISIONS));
float bevelTriangleHeight = innerDisplacementLen + lineWidth * cos(theta * 0.5);
float triangleHeight = NUM_JOIN_SUBDIVISIONS > 0.0 ? subdividedTriangleHeight : bevelTriangleHeight;
vStretchFactor = noPerspectiveWrite(max(triangleHeight / (2.0 * lineWidth), 1.0), pos.w);
}
}`),z.main.add(S.H`if (isOutside && (displacementLen > miterLimit * lineWidth)) {`),F?z.main.add(S.H`
        vec3 startDir = leftLen < EPS ? right : left;
        startDir = perpendicular(startDir);

        vec3 endDir = rightLen < EPS ? left : right;
        endDir = perpendicular(endDir);

        float factor = ${W?S.H`min(1.0, subdivisionFactor * ((NUM_JOIN_SUBDIVISIONS + 1.0) / NUM_JOIN_SUBDIVISIONS))`:S.H`subdivisionFactor`};

        float rotationAngle = acos(clamp(dot(startDir.xy, endDir.xy), -1.0, 1.0));
        joinDisplacementDir = rotateZ(startDir, -sign(lineParameters.y) * factor * rotationAngle);
      `):z.main.add(S.H`
        vec3 startDir = perpendicular(leftLen < EPS ? right : left);
        vec3 endDir = perpendicular(rightLen < EPS ? left : right);

        ${(0,S.If)(W,S.H`joinDisplacementDir = (isStartVertex || subdivisionFactor > 0.0) ? endDir : startDir;`,S.H`joinDisplacementDir = mix(startDir, endDir, subdivisionFactor);`)}
  `);const $=0!==R;return z.main.add(S.H`
        displacementLen = lineWidth;
      }
    } else {
      // CAP handling ---------------------------------------------------
      joinDisplacementDir = isStartVertex ? right : left;
      joinDisplacementDir = perpendicular(joinDisplacementDir);

      ${$?S.H`capDisplacementDir = vec3((isStartVertex ? -right : left).xy, 0.0);`:""}
    }
  `),z.main.add(S.H`
    // Displacement (in pixels) caused by join/or cap
    vec2 dposXY = (joinDisplacementDir.xy * sign(lineParameters.y) + capDisplacementDir.xy) * displacementLen;

    /**
     * To prevent z-fighting between layers, we also adjust the z value.
     * We want to ensure that the orientation of the final triangles is the same, regardless of the line width.
     * To do so, the below formula projects the xy displacement onto the original segment direction
     * to find the z-offset necessary so the triangle orientation is independent of the width.
     */
    float dposZ = dot(dposXY, segmentDirection.xy) / dot(segmentDirection.xy, segmentDirection.xy) * segmentDirection.z;
    vec3 dpos = vec3(dposXY, dposZ);

    float lineDistNorm = noPerspectiveWrite(sign(lineParameters.y), pos.w);

    vLineDistance = lineWidth * lineDistNorm;
    ${B?S.H`vLineDistanceNorm = lineDistNorm;`:""}

    pos.xyz += dpos;
  `),W||z.main.add(S.H`if (isJoin) {
vec2 joinCenterToVertex = dposXY;
vec2 leftCenterlineDir = left.xy;
vec2 rightCenterlineDir = right.xy;
float leftCenterlineLen = length(leftCenterlineDir);
float rightCenterlineLen = length(rightCenterlineDir);
leftCenterlineDir = leftCenterlineLen > EPS ? leftCenterlineDir / leftCenterlineLen : vec2(1.0, 0.0);
rightCenterlineDir = rightCenterlineLen > EPS ? rightCenterlineDir / rightCenterlineLen : leftCenterlineDir;
vJoinCenterLineSDFs = noPerspectiveWrite(
vec2(
dot(vec2(rightCenterlineDir.y, -rightCenterlineDir.x), joinCenterToVertex),
dot(vec2(leftCenterlineDir.y, -leftCenterlineDir.x), joinCenterToVertex)
),
pos.w
);
}`),j&&z.main.add(S.H`vec2 segmentDir = normalize(segment.xy);
vSegmentSDF = noPerspectiveWrite((isJoin && isStartVertex) ? LARGE_HALF_FLOAT : (dot(pos.xy - segmentOrigin.xy, segmentDir)), pos.w);
vReverseSegmentSDF = noPerspectiveWrite((isJoin && !isStartVertex) ? LARGE_HALF_FLOAT : (dot(pos.xy - segmentEnd.xy, -segmentDir)), pos.w);`),W&&(L?z.uniforms.add(new v.U("worldToScreenRatio",e=>1/e.screenToPCSRatio)):z.main.add(S.H`vec3 segmentCenter = mix((nextPosition + position) * 0.5, (position + prevPosition) * 0.5, isEndVertex);
float worldToScreenRatio = computeWorldToScreenRatio(segmentCenter);`),z.main.add(S.H`float segmentLengthScreenDouble = length(segment.xy);
float segmentLengthScreen = segmentLengthScreenDouble * 0.5;
float discreteWorldToScreenRatio = discretizeWorldToScreenRatio(worldToScreenRatio);
float segmentLengthRender = length(mix(nextPosition - position, position - prevPosition, isEndVertex));
vStipplePatternStretch = worldToScreenRatio / discreteWorldToScreenRatio;`),L?z.main.add(S.H`float segmentLengthPseudoScreen = segmentLengthScreen / pixelRatio * discreteWorldToScreenRatio / worldToScreenRatio;
float startPseudoScreen = u0 * discreteWorldToScreenRatio - mix(0.0, segmentLengthPseudoScreen, isEndVertex);`):z.main.add(S.H`float startPseudoScreen = mix(u0, u0 - segmentLengthRender, isEndVertex) * discreteWorldToScreenRatio;
float segmentLengthPseudoScreen = segmentLengthRender * discreteWorldToScreenRatio;`),z.uniforms.add(new g.m("stipplePatternPixelSize",e=>(0,o.h)(e))),z.main.add(S.H`
      float patternLength = patternLineSize * stipplePatternPixelSize;

      ${(0,S.If)(H,S.H`
          float uu = mix(u0, u0 - segmentLengthRender, isEndVertex);
          vStippleDistanceLimits = vec2(uu, uu + segmentLengthRender);
          vStipplePatternStretch = 1.0;

          // The v-coordinate used in case of an image pattern.
          bool isLeft = sign(lineParameters.y) < 0.0;
          vStippleV = isLeft ? 0.0 : 1.0;
        `,S.H`
          // Compute the coordinates at both start and end of the line segment, because we need both to clamp to in the
          // fragment shader
          vStippleDistanceLimits = computeStippleDistanceLimits(startPseudoScreen, segmentLengthPseudoScreen, segmentLengthScreen, patternLength);
        `)}

      vStippleDistance = mix(vStippleDistanceLimits.x, vStippleDistanceLimits.y, isEndVertex);

      // Adjust the coordinate to the displaced position (the pattern is shortened/overextended on the in/outside of
      // joins)
      if (segmentLengthScreenDouble >= EPS) {
        // Project the actual vertex position onto the line segment. Note that the resulting factor is within [0..1]
        // at the original vertex positions, and slightly outside of that range at the displaced positions
        vec3 stippleDisplacement = pos.xyz - segmentOrigin;
        float stippleDisplacementFactor = dot(segment.xy, stippleDisplacement.xy) / (segmentLengthScreenDouble * segmentLengthScreenDouble);

        // Apply this offset to the actual vertex coordinate (can be screen or pseudo-screen space)
        vStippleDistance += (stippleDisplacementFactor - isEndVertex) * (vStippleDistanceLimits.y - vStippleDistanceLimits.x);
      }

      // Cancel out perspective correct interpolation because we want this length the really represent the screen
      // distance
      vStippleDistanceLimits = noPerspectiveWrite(vStippleDistanceLimits, pos.w);
      vStippleDistance = noPerspectiveWrite(vStippleDistance, pos.w);

      // Disable stipple distance limits on caps
      vStippleDistanceLimits = isJoin ?
                                 vStippleDistanceLimits :
                                 isStartVertex ?
                                  vec2(-1e34, vStippleDistanceLimits.y) :
                                  vec2(vStippleDistanceLimits.x, 1e34);
    `)),z.main.add(S.H`
      // Convert back into NDC
      pos.xy = (pos.xy / viewport.zw) * pos.w;
      pos.z = pos.z * pos.w;

      vColor = getColor();
      vColor.a = noPerspectiveWrite(vColor.a * coverage, pos.w);

      ${E&&!L?"pos.z -= EPS * pos.w;":""}

      // transform final position to camera space for slicing
      vpos = (inverseProjectionMatrix * pos).xyz;
      gl_Position = pos;
      forwardObjectAndLayerIdColor();
    }`),t.fragment.include(n.HQ,e),t.include(C.D,e),P.include(d.a),P.main.add(S.H`discardBySlice(vpos);`),t.include(p.m),P.include(y.Q),P.main.add(S.H`
    float lineWidth = noPerspectiveRead(vLineWidth);
    float lineDistance = noPerspectiveRead(vLineDistance);
    ${(0,S.If)(B,S.H`float lineDistanceNorm = noPerspectiveRead(vLineDistanceNorm);`)}
  `),E?P.main.add(S.H`vec4 finalColor = vec4(1.0, 0.0, 1.0, 1.0);`):(j&&P.main.add(S.H`float sdf = noPerspectiveRead(min(vSegmentSDF, vReverseSegmentSDF));
vec2 fragmentPosition = vec2(min(sdf, 0.0), lineDistance);
float fragmentRadius = length(fragmentPosition);
float fragmentCapSDF = (fragmentRadius - lineWidth) * 0.5;
float capCoverage = clamp(0.5 - fragmentCapSDF, 0.0, 1.0);
if (capCoverage < alphaCutoff) {
discard;
}`),k?P.main.add(S.H`vec2 stipplePosition = vec2(
min(getStippleSDF() * 2.0 - 1.0, 0.0),
lineDistanceNorm
);
float stippleRadius = length(stipplePosition * lineWidth);
float stippleCapSDF = (stippleRadius - lineWidth) * 0.5;
float stippleCoverage = clamp(0.5 - stippleCapSDF, 0.0, 1.0);
float stippleAlpha = step(alphaCutoff, stippleCoverage);`):P.main.add(S.H`float stippleAlpha = getStippleAlpha(lineWidth);`),11!==O&&P.main.add(S.H`discardByStippleAlpha(stippleAlpha, alphaCutoff);`),t.include(p.m),P.uniforms.add(new m.E("intrinsicColor",e=>e.color)).main.add(S.H`vec4 color = intrinsicColor * vColor;
color.a = noPerspectiveRead(color.a);`),A&&P.uniforms.add(new m.E("innerColor",e=>e.innerColor??e.color),new g.m("innerWidth",(e,t)=>e.innerWidth*t.camera.pixelRatio)).main.add(S.H`float distToInner = abs(lineDistance) - innerWidth;
float innerAA = clamp(0.5 - distToInner, 0.0, 1.0);
float innerAlpha = innerColor.a + color.a * (1.0 - innerColor.a);
color = mix(color, vec4(innerColor.rgb, innerAlpha), innerAA);`),P.main.add(S.H`vec4 finalColor = blendStipple(color, stippleAlpha);`),_&&(P.uniforms.add(new g.m("falloff",e=>e.falloff)),P.main.add(S.H`finalColor.a *= pow(max(0.0, 1.0 - abs(lineDistanceNorm)), falloff);`)),W||P.main.add(S.H`float stretchFactor = vIsInsideJoin == 1 ? noPerspectiveRead(vStretchFactor) : 1.0;
float featherWidth = 2.0;
float featherStartDistance = max(lineWidth - featherWidth / stretchFactor, 0.0);
float straightFeatherStartDistance = max(lineWidth - featherWidth, 0.0);
float value = abs(lineDistance);
float feather = (value - featherStartDistance) / (lineWidth - featherStartDistance);
vec2 joinCenterSDFs = noPerspectiveRead(vJoinCenterLineSDFs);
float joinCenterDistance = abs(vSubdivisionFactor > 0.5 ? joinCenterSDFs.x : joinCenterSDFs.y);
float straightFeather = (joinCenterDistance - straightFeatherStartDistance) / (lineWidth - straightFeatherStartDistance);
feather = vIsInsideJoin == 1 ? max(feather, straightFeather) : feather;
finalColor.a *= 1.0 - clamp(feather, 0.0, 1.0);`),I&&P.main.add(S.H`
        finalColor = animate(finalColor);

        ${(0,S.If)(11!==O,S.H`
            if (finalColor.a <= alphaCutoff) {
              discard;
            }`)}
      `)),P.main.add(S.H`outputColorHighlightOLID(applySlice(finalColor, vpos), finalColor.rgb);`),t}const z=Object.freeze(Object.defineProperty({__proto__:null,build:T,ribbonlineNumRoundJoinSubdivisions:1},Symbol.toStringTag,{value:"Module"}));i.d(t,["R",0,z])},5822(e,t,i){i.d(t,{I2:()=>f,Kf:()=>m,Uk:()=>S,ai:()=>g,au:()=>d,fe:()=>v,nG:()=>h,nu:()=>u,sE:()=>p});var n=i(25336),r=i(26110),a=i(19913),o=i(63540),s=i(88133);if(73942==i.j)var l=i(75423);if(73942==i.j)var c=i(2568);function d(e,t,i,n,r,a,o,l,c,d,p){const h=x[p.mode];let f,u,m=0;if((0,s.projectBuffer)(e,t,i,n,c.spatialReference,r,l))return h?.requiresAlignment(p)?(m=h.applyElevationAlignmentBuffer(n,r,a,o,l,c,d,p),f=a,u=o):(f=n,u=r),(0,s.projectBuffer)(f,c.spatialReference,u,a,d.spatialReference,o,l)?m:void 0}function p(e,t,i,n,r){const a=((0,l.v)(e)?e.z:(0,c.cN)(e)?e.array[e.offset+2]:e[2])||0;switch(i.mode){case"on-the-ground":{const i=(0,c.R1)(t,e,"ground")??0;return r.verticalDistanceToGround=0,r.sampledElevation=i,void(r.z=i)}case"relative-to-ground":{const o=(0,c.R1)(t,e,"ground")??0,s=i.geometryZWithOffset(a,n);return r.verticalDistanceToGround=s,r.sampledElevation=o,void(r.z=s+o)}case"relative-to-scene":{const o=(0,c.R1)(t,e,"scene")??0,s=i.geometryZWithOffset(a,n);return r.verticalDistanceToGround=s,r.sampledElevation=o,void(r.z=s+o)}case"absolute-height":{const o=i.geometryZWithOffset(a,n),s=(0,c.R1)(t,e,"ground")??0;return r.verticalDistanceToGround=o-s,r.sampledElevation=s,void(r.z=o)}default:return void(r.z=0)}}function h(e,t,i,n){return p(e,t,i,n,b),b.z}function f(e,t,i){return"on-the-ground"===t&&"on-the-ground"===i?e.staysOnTheGround:t===i||"on-the-ground"!==t&&"on-the-ground"!==i?null==t||null==i?e.definedChanged:1:e.onTheGroundChanged}function u(e){return"relative-to-ground"===e||"relative-to-scene"===e}function m(e){return"absolute-height"!==e}function v(e,t,i,r,a){p(t,i,a,r,b),g(e,b.verticalDistanceToGround);const s=b.sampledElevation,l=(0,n.C)(y,e.transformation);return C[0]=t.x,C[1]=t.y,C[2]=b.z,(0,o.l)(t.spatialReference,C,l,r.spatialReference)?e.transformation=l:console.warn("Could not locate symbol object properly, it might be misplaced"),s}function g(e,t){for(let i=0;i<e.geometries.length;++i){const n=e.geometries[i].getMutableAttribute("groundDistance");n&&n.data[0]!==t&&(n.data[0]=t,e.geometryVertexAttributeUpdated(e.geometries[i],"groundDistance"))}}class S{constructor(){this.verticalDistanceToGround=0,this.sampledElevation=0,this.z=0}}const x=73942==i.j?{"absolute-height":{applyElevationAlignmentBuffer:function(e,t,i,n,r,a,o,s){const l=s.calculateOffsetRenderUnits(o),c=s.featureExpressionInfoContext;t*=3,n*=3;for(let a=0;a<r;++a){const r=e[t],a=e[t+1],o=e[t+2];i[n]=r,i[n+1]=a,i[n+2]=null==c?o+l:l,t+=3,n+=3}return 0},requiresAlignment:function(e){const t=e.meterUnitOffset,i=e.featureExpressionInfoContext;return 0!==t||null!=i}},"on-the-ground":{applyElevationAlignmentBuffer:function(e,t,i,n,r,a){let o=0;const s=a.spatialReference;t*=3,n*=3;for(let l=0;l<r;++l){const r=e[t],l=e[t+1],c=e[t+2],d=a.getElevation(r,l,c,s,"ground")??0;o+=d,i[n]=r,i[n+1]=l,i[n+2]=d,t+=3,n+=3}return o/r},requiresAlignment:()=>!0},"relative-to-ground":{applyElevationAlignmentBuffer:function(e,t,i,n,r,a,o,s){let l=0;const c=s.calculateOffsetRenderUnits(o),d=s.featureExpressionInfoContext,p=a.spatialReference;t*=3,n*=3;for(let o=0;o<r;++o){const r=e[t],o=e[t+1],s=e[t+2],h=a.getElevation(r,o,s,p,"ground")??0;l+=h,i[n]=r,i[n+1]=o,i[n+2]=null==d?s+h+c:h+c,t+=3,n+=3}return l/r},requiresAlignment:()=>!0},"relative-to-scene":{applyElevationAlignmentBuffer:function(e,t,i,n,r,a,o,s){let l=0;const c=s.calculateOffsetRenderUnits(o),d=s.featureExpressionInfoContext,p=a.spatialReference;t*=3,n*=3;for(let o=0;o<r;++o){const r=e[t],o=e[t+1],s=e[t+2],h=a.getElevation(r,o,s,p,"scene")??0;l+=h,i[n]=r,i[n+1]=o,i[n+2]=null==d?s+h+c:h+c,t+=3,n+=3}return l/r},requiresAlignment:()=>!0}}:null,y=(0,r.vt)(),b=new S,C=(0,a.vt)()},4498(e,t,i){i(11519),i(68716),i(22497),i(88416)},11519(e,t,i){i.d(t,{ny:()=>l,sZ:()=>c});var n=i(76982),r=i(26797),a=i(68716);const o=.5,s=(0,n.CN)(o/2,o/2,.75,.75);function l(e){return"cross"===e||"x"===e}function c(e,t=128,i=t*o,n=0){const{data:s,parameters:l}=function(e,t=128,i=t*o,n=0){return{data:d(e,t,i,n),parameters:{mipmap:!1,wrap:{s:33071,t:33071},width:t,height:t,noUnpackFlip:!0,dataType:a.ld.FLOAT,pixelFormat:6403,internalFormat:a.H0.R16F,reloadable:!0}}}(e,t,i,n);return new r.h(s,l)}function d(e,t=128,i=t*o,n=0){switch(e){case"circle":default:return function(e,t){const i=e/2-.5;return m(e,f(i,i,t/2))}(t,i);case"square":return function(e,t){return p(e,t,!1)}(t,i);case"cross":return function(e,t,i=0){return h(e,t,!1,i)}(t,i,n);case"x":return function(e,t,i=0){return h(e,t,!0,i)}(t,i,n);case"kite":return function(e,t){return p(e,t,!0)}(t,i);case"triangle":return function(e,t){return m(e,u(e/2,t,t/2))}(t,i);case"arrow":return function(e,t){const i=t,n=t/2,r=e/2,a=.8*i,o=f(r,(e-t)/2-a,Math.sqrt(a*a+n*n)),s=u(r,i,n);return m(e,(e,t)=>Math.max(s(e,t),-o(e,t)))}(t,i)}}function p(e,t,i){return i&&(t/=Math.SQRT2),m(e,(n,r)=>{let a=n-.5*e+.25,o=.5*e-r-.75;if(i){const e=(a+o)/Math.SQRT2;o=(o-a)/Math.SQRT2,a=e}return Math.max(Math.abs(a),Math.abs(o))-.5*t})}function h(e,t,i,n=0){t-=n,i&&(t*=Math.SQRT2);const r=.5*t;return m(e,(t,a)=>{let o,s=t-.5*e,l=.5*e-a-1;if(i){const e=(s+l)/Math.SQRT2;l=(l-s)/Math.SQRT2,s=e}return s=Math.abs(s),l=Math.abs(l),o=s>l?s>r?Math.sqrt((s-r)*(s-r)+l*l):l:l>r?Math.sqrt(s*s+(l-r)*(l-r)):s,o-=n/2,o})}function f(e,t,i){return(n,r)=>{const a=n-e,o=r-t;return Math.sqrt(a*a+o*o)-i}}function u(e,t,i){const n=Math.sqrt(t*t+i*i);return(r,a)=>{const o=Math.abs(r-e)-i,s=a-e+t/2+.75,l=(t*o+i*s)/n,c=-s;return Math.max(l,c)}}function m(e,t){const i=new Float32Array(e*e);for(let n=0;n<e;n++)for(let r=0;r<e;r++)i[r+e*n]=t(r,n)/e;return i}i.d(t,["PY",0,s])},37303(e,t,i){i.d(t,{s:()=>f});var n=i(25336),r=i(26110),a=i(24578),o=i(15510),s=i(21586),l=i(64802),c=i(19635),d=i(4930),p=i(62462),h=i(73813);function f(e,t){const{vertex:i,attributes:r}=e;i.uniforms.add(new c.m("intrinsicWidth",e=>e.width));const{hasScreenSizePerspective:f,spherical:m}=t;f?(e.include(o.Y6,t),(0,o.pM)(i),(0,s.yu)(i,t),i.uniforms.add(new h.S("inverseViewMatrix",(e,t)=>(0,n.B8)(u,(0,n.Tl)(u,t.camera.viewMatrix,e.origin)))),i.code.add(p.H`
      float applyLineSizeScreenSizePerspective(float size, vec3 pos) {
        vec3 worldPos = (inverseViewMatrix * vec4(pos, 1)).xyz;
        vec3 groundUp = ${m?p.H`normalize(worldPos + localOrigin)`:p.H`vec3(0.0, 0.0, 1.0)`};
        float absCosAngle = abs(dot(groundUp, normalize(worldPos - cameraPosition)));

        return screenSizePerspectiveScaleFloat(size, absCosAngle, length(pos), screenSizePerspective);
      }
    `)):i.code.add(p.H`float applyLineSizeScreenSizePerspective(float size, vec3 pos) {
return size;
}`),t.hasVVSize?(r.add("sizeFeatureAttribute","float"),i.uniforms.add(new l.t("vvSizeMinSize",e=>e.vvSize.minSize),new l.t("vvSizeMaxSize",e=>e.vvSize.maxSize),new l.t("vvSizeOffset",e=>e.vvSize.offset),new l.t("vvSizeFactor",e=>e.vvSize.factor),new l.t("vvSizeFallback",e=>e.vvSize.fallback)),i.code.add(p.H`
    float getSize(${(0,p.If)(f,"vec3 pos")}) {
      float size = isnan(sizeFeatureAttribute)
        ? vvSizeFallback.x
        : intrinsicWidth * clamp(vvSizeOffset + sizeFeatureAttribute * vvSizeFactor, vvSizeMinSize, vvSizeMaxSize).x;

      return ${(0,p.If)(f,"applyLineSizeScreenSizePerspective(size, pos)","size")};
    }
    `)):(r.add("size","float"),i.code.add(p.H`
    float getSize(${(0,p.If)(f,"vec3 pos")}) {
      float fullSize = intrinsicWidth * size;
      return ${(0,p.If)(f,"applyLineSizeScreenSizePerspective(fullSize, pos)","fullSize")};
    }
    `)),t.hasVVOpacity?(r.add("opacityFeatureAttribute","float"),i.constants.add("vvOpacityNumber","int",8),i.uniforms.add(new d.x("vvOpacityValues",8,e=>e.vvOpacity.values),new d.x("vvOpacityOpacities",8,e=>e.vvOpacity.opacityValues),new c.m("vvOpacityFallback",e=>e.vvOpacity.fallback,{supportsNaN:!0})),i.code.add(p.H`
    float interpolateOpacity(float value) {
      if (value <= vvOpacityValues[0]) {
        return vvOpacityOpacities[0];
      }

      for (int i = 1; i < vvOpacityNumber; ++i) {
        if (vvOpacityValues[i] >= value) {
          float f = (value - vvOpacityValues[i-1]) / (vvOpacityValues[i] - vvOpacityValues[i-1]);
          return mix(vvOpacityOpacities[i-1], vvOpacityOpacities[i], f);
        }
      }

      return vvOpacityOpacities[vvOpacityNumber - 1];
    }

    vec4 applyOpacity(vec4 color) {
      if (isnan(opacityFeatureAttribute)) {
        // If there is a color vv then it will already have taken care of applying the fallback
        return ${(0,p.If)(t.hasVVColor,"color","vec4(color.rgb, vvOpacityFallback)")};
      }

      return vec4(color.rgb, interpolateOpacity(opacityFeatureAttribute));
    }
    `)):i.code.add(p.H`vec4 applyOpacity(vec4 color) {
return color;
}`),t.hasVVColor?(e.include(a.A,t),r.add("colorFeatureAttribute","float"),i.code.add(p.H`vec4 getColor() {
vec4 color = interpolateVVColor(colorFeatureAttribute);
if (isnan(color.r)) {
return vec4(0);
}
return applyOpacity(color);
}`)):(r.add("color","vec4"),i.code.add(p.H`vec4 getColor() {
return applyOpacity(color);
}`))}const u=(0,r.vt)()},77802(e,t,i){i.d(t,{q:()=>v,h:()=>g});var n=i(79377),r=i(33560),a=i(21586),o=i(92121),s=i(41281),l=i(19635),c=i(62462),d=i(19778),p=i(51310);function h(e){if(null==e)return 1;const t=function(e){return e.pattern.map(t=>Math.round(t*e.pixelRatio))}(e);return Math.floor(t.reduce((e,t)=>e+t))}i(68716),i(22497),i(88416);var f=i(71072),u=i(76982);const m=(0,u.vt)();function v(e,t){if(!t.stippleEnabled)return void e.fragment.code.add(c.H`float getStippleAlpha(float lineWidth) { return 1.0; }
void discardByStippleAlpha(float stippleAlpha, float threshold) {}
vec4 blendStipple(vec4 color, float stippleAlpha) { return color; }`);const i=!(t.draped&&t.stipplePreferContinuous),{vertex:p,fragment:h}=e;t.draped||((0,a.yu)(p,t),p.uniforms.add(new s.U("worldToScreenPerDistanceRatio",({camera:e})=>1/e.perScreenPixelRatio)).code.add(c.H`float computeWorldToScreenRatio(vec3 segmentCenter) {
float segmentDistanceToCamera = length(segmentCenter - cameraPosition);
return worldToScreenPerDistanceRatio / segmentDistanceToCamera;
}`)),e.varyings.add("vStippleDistance","float"),e.varyings.add("vStippleDistanceLimits","vec2"),e.varyings.add("vStipplePatternStretch","float"),p.code.add(c.H`
    float discretizeWorldToScreenRatio(float worldToScreenRatio) {
      float step = ${c.H.float(S)};

      float discreteWorldToScreenRatio = log(worldToScreenRatio);
      discreteWorldToScreenRatio = ceil(discreteWorldToScreenRatio / step) * step;
      discreteWorldToScreenRatio = exp(discreteWorldToScreenRatio);
      return discreteWorldToScreenRatio;
    }
  `),(0,a.Nz)(p),p.code.add(c.H`
    vec2 computeStippleDistanceLimits(float startPseudoScreen, float segmentLengthPseudoScreen, float segmentLengthScreen, float patternLength) {

      // First check if the segment is long enough to support fully screen space patterns.
      // Force sparse mode for segments that are very large in screen space even if it is not allowed,
      // to avoid imprecision from calculating with large floats.
      if (segmentLengthPseudoScreen >= ${i?"patternLength":"1e4"}) {
        // Round the screen length to get an integer number of pattern repetitions (minimum 1).
        float repetitions = segmentLengthScreen / (patternLength * pixelRatio);
        float flooredRepetitions = max(1.0, floor(repetitions + 0.5));
        float segmentLengthScreenRounded = flooredRepetitions * patternLength;

        float stretch = repetitions / flooredRepetitions;

        // We need to impose a lower bound on the stretch factor to prevent the dots from merging together when there is only 1 repetition.
        // 0.75 is the lowest possible stretch value for flooredRepetitions > 1, so it makes sense as lower bound.
        vStipplePatternStretch = max(0.75, stretch);

        return vec2(0.0, segmentLengthScreenRounded);
      }
      return vec2(startPseudoScreen, startPseudoScreen + segmentLengthPseudoScreen);
    }
  `),h.uniforms.add(new d.N("stipplePatternTexture",e=>e.stippleTexture),new l.m("stipplePatternPixelSizeInv",e=>1/g(e))),t.stippleOffColorEnabled&&h.uniforms.add(new o.E("stippleOffColor",e=>{return null==(t=e.stippleOffColor)?u.uY:4===t.length?t:(0,f.hZ)(m,t[0],t[1],t[2],1);var t})),e.include(r.m),t.worldSizedImagePattern?(e.varyings.add("vStippleV","float"),e.fragment.include(n.N),h.code.add(c.H`vec4 getStippleColor(out bool isClamped) {
vec2 aaCorrectedLimits = vStippleDistanceLimits + vec2(1.0, -1.0) / gl_FragCoord.w;
isClamped = vStippleDistance < aaCorrectedLimits.x || vStippleDistance > aaCorrectedLimits.y;
float u = vStippleDistance * stipplePatternPixelSizeInv;
float v = vStippleV == -1.0 ? 0.5 : vStippleV;
return texture(stipplePatternTexture, vec2(u, v));
}
vec4 getStippleColor() {
bool ignored;
return getStippleColor(ignored);
}
float getStippleSDF() {
vec4 color = getStippleColor();
return color.a == 0.0 ? -0.5 : 0.5;
}
float getStippleAlpha(float lineWidth) {
return getStippleColor().a;
}
vec4 blendStipple(vec4 color, float stippleAlpha) {
vec4 stippleColor = getStippleColor();
int mixMode  = 1;
vec3 col = mixExternalColor(color.rgb, vec3(1.0), stippleColor.rgb, mixMode);
float opacity = mixExternalOpacity(color.a, 1.0, stippleColor.a, mixMode);
return vec4(col, opacity);
}`)):h.code.add(c.H`
    float getStippleSDF(out bool isClamped) {
      float stippleDistanceClamped = noPerspectiveRead(clamp(vStippleDistance, vStippleDistanceLimits.x, vStippleDistanceLimits.y));
      float lineSizeInv = noPerspectiveRead(vLineSizeInv);

      vec2 aaCorrectedLimits = vStippleDistanceLimits + vec2(1.0, -1.0) / gl_FragCoord.w;
      isClamped = vStippleDistance < aaCorrectedLimits.x || vStippleDistance > aaCorrectedLimits.y;

      float u = stippleDistanceClamped * stipplePatternPixelSizeInv * lineSizeInv;
      u = fract(u);

      float sdf = texture(stipplePatternTexture, vec2(u, 0.5)).r;

      return (sdf - 0.5) * vStipplePatternStretch + 0.5;
    }

    float getStippleSDF() {
      bool ignored;
      return getStippleSDF(ignored);
    }

    float getStippleAlpha(float lineWidth) {
      bool isClamped;
      float stippleSDF = getStippleSDF(isClamped);
      float antiAliasedResult = clamp(stippleSDF * lineWidth + 0.5, 0.0, 1.0);
      return isClamped ? floor(antiAliasedResult + 0.5) : antiAliasedResult;
    }

    vec4 blendStipple(vec4 color, float stippleAlpha) {
      return ${t.stippleOffColorEnabled?"mix(color, stippleOffColor, stippleAlpha)":"vec4(color.rgb, color.a * stippleAlpha)"};
    }
  `),h.code.add(c.H`
    void discardByStippleAlpha(float stippleAlpha, float threshold) {
     ${(0,c.If)(!t.stippleOffColorEnabled,"if (stippleAlpha < threshold) { discard; }")}
    }
  `)}function g(e){const t=e.stipplePattern;return(0,p.sL)(t)?t.length:t?h(t)/t.pixelRatio:1}const S=.4},47913(e,t,i){i.d(t,{r:()=>o}),i(4498);var n=i(21586),r=i(41281),a=i(62462);function o(e,t){const i=e.vertex,o=t.hasScreenSizePerspective;(0,n.Nz)(i),null==i.uniforms.get("markerScale")&&i.constants.add("markerScale","float",1),i.constants.add("markerSizePerLineWidth","float",10).code.add(a.H`
  float getLineWidth(${(0,a.If)(o,"vec3 pos")}) {
     return max(getSize(${(0,a.If)(o,"pos")}), 1.0) * pixelRatio;
  }

  float getScreenMarkerSize(float lineWidth) {
    return markerScale * markerSizePerLineWidth * lineWidth;
  }
  `),2===t.space&&(i.constants.add("maxSegmentLengthFraction","float",.45),i.uniforms.add(new r.U("perRenderPixelRatio",e=>e.camera.perRenderPixelRatio)),i.code.add(a.H`
  bool areWorldMarkersHidden(vec3 pos, vec3 other) {
    vec3 midPoint = mix(pos, other, 0.5);
    float distanceToCamera = length(midPoint);
    float screenToWorldRatio = perRenderPixelRatio * distanceToCamera * 0.5;
    float worldMarkerSize = getScreenMarkerSize(getLineWidth(${(0,a.If)(o,"pos")})) * screenToWorldRatio;
    float segmentLen = length(pos - other);
    return worldMarkerSize > maxSegmentLengthFraction * segmentLen;
  }

  float getWorldMarkerSize(vec3 pos) {
    float distanceToCamera = length(pos);
    float screenToWorldRatio = perRenderPixelRatio * distanceToCamera * 0.5;
    return getScreenMarkerSize(getLineWidth(${(0,a.If)(o,"pos")})) * screenToWorldRatio;
  }
  `))}},9717(e,t,i){const n=i(62462).H`vec4(0.0, 0.0, 2.0, 1.0)`;i.d(t,["Z",0,n])},33560(e,t,i){function n(e){e.vertex.code.add("#define noPerspectiveWrite(x, w) (x * w)")}function r(e){e.fragment.code.add("#define noPerspectiveRead(x) (x * gl_FragCoord.w)")}i.d(t,{F:()=>n,m:()=>r})},45072(e,t,i){i.d(t,{g:()=>v}),i(6273);var n=i(78851),r=i(72906),a=i(71573),o=i(19913),s=i(76982),l=i(88133),c=i(10941),d=i(40753),p=i(96024),h=i(54909),f=i(58304),u=i(5415),m=i(8185);class v{constructor(e){this._originSR=e,this._rootOriginId="root/"+(0,n.c)(),this._origins=new Map,this._objects=new Map,this._gridSize=5e5,this._originSR?.isGeographic&&(this._gridSize/=(0,r.GA)(this._originSR)),this._baselineDistance=.5*this._gridSize;const t=this._baselineDistance*S;this._baselineObjectSize=t/x}getOrigin(e){const t=this._origins.get(this._rootOriginId);if(null==t){const t=f.Q.rootOrigin;if(null!=t)return this._origins.set(this._rootOriginId,(0,p.f)(t[0],t[1],t[2],this._rootOriginId)),this.getOrigin(e);const i=(0,p.f)(e[0]+Math.random()-.5,e[1]+Math.random()-.5,e[2]+Math.random()-.5,this._rootOriginId);return this._origins.set(this._rootOriginId,i),i}const i=this._gridSize,n=Math.round(e[0]/i),r=Math.round(e[1]/i),o=Math.round(e[2]/i),s=`${n}/${r}/${o}`;let l=this._origins.get(s);const c=.5*i;if((0,a.Re)(g,e,t.vec3),g[0]=Math.abs(g[0]),g[1]=Math.abs(g[1]),g[2]=Math.abs(g[2]),g[0]<c&&g[1]<c&&g[2]<c){if(l){const t=Math.max(...g);if((0,a.Re)(g,e,l.vec3),g[0]=Math.abs(g[0]),g[1]=Math.abs(g[1]),g[2]=Math.abs(g[2]),Math.max(...g)<t)return l}return t}return l||(l=(0,p.f)(n*i,r*i,o*i,s),this._origins.set(s,l)),l}needsOriginUpdate(e,t,i){const n=(0,a.Io)(e.vec3,t),r=Math.max(1,i/this._baselineObjectSize);return n>this._baselineDistance*r}_drawOriginBox(e,t=(0,s.fA)(1,1,0,1)){const i=window.view,n=i.stage,r=t.toString();if(!this._objects.has(r)){this._material=new m.W({width:2,color:t},!1);const e=new u.x(n,{pickable:!1}),i=new h.B({castShadow:!1});e.add(i),this._objects.set(r,i)}const a=this._objects.get(r),o=[0,1,5,4,0,2,1,7,6,2,0,1,3,7,5,4,6,2,0],p=o.length,f=new Array(3*p),v=new Array,g=.5*this._gridSize;for(let t=0;t<p;t++)f[3*t]=e[0]+(1&o[t]?g:-g),f[3*t+1]=e[1]+(2&o[t]?g:-g),f[3*t+2]=e[2]+(4&o[t]?g:-g),t>0&&v.push(t-1,t);(0,l.projectBuffer)(f,this._originSR,0,f,i.renderSpatialReference,0,p);const S=new d.V(this._material,[["position",new c.n(f,v,3,!0)]],null,2);a.addGeometry(S)}get test(){}}const g=(0,o.vt)(),S=2**-23,x=.05},96024(e,t,i){i.d(t,{f:()=>a});var n=i(19913);class r{constructor(e,t){this.vec3=e,this.id=t}}function a(e,t,i,a){return new r((0,n.fA)(e,t,i),a)}},58304(e,t,i){const n=73942==i.j?{stableRendering:!1}:null;i.d(t,["G",0,n,"Q",0,{rootOrigin:null}])},8185(e,t,i){i.d(t,{W:()=>N});var n=i(80861),r=i(4506),a=i(23572),o=i(67900),s=i(53334),l=i(71573),c=i(19913),d=i(71072),p=i(76982),h=i(81627),f=i(94669),u=i(87368),m=i(77788),v=i(84618),g=i(76687),S=i(31272),x=i(84231),y=i(26421),b=i(51310),C=i(34383),D=i(29290),T=i(46348),z=i(7724);function P(e){const t=(0,z.BP)().vec3f("position").vec4f16("previousDelta").vec4f16("nextDelta").f32("u0").vec2f16("lineParameters");return e.hasVVColor?t.f32("colorFeatureAttribute"):t.vec4u8("color",{glNormalized:!0}),e.hasVVSize?t.f32("sizeFeatureAttribute"):t.f32("size"),e.hasVVOpacity&&t.f32("opacityFeatureAttribute"),(0,v.E)()&&t.vec4u8("olidColor"),e.hasAnimation&&t.vec4f16("timeStamps"),t}var w=i(31635),L=i(69636),O=i(29386),R=i(70051),W=i(73218),_=i(8445),F=i(28116),E=i(28849),A=i(68716),I=i(15651);let V=class extends W.w{constructor(e,t){super(e,t,(0,O.U)(P(t))),this.shader=new R.r(T.R,()=>i.e(53740).then(i.bind(i,53740))),this.ignoreUnused=!0,this.primitiveType=t.wireframe?A.WR.LINES:A.WR.TRIANGLE_STRIP}_makePipelineState(e,t){const{output:i,hasOccludees:n}=e;return(0,I.Ey)({blending:(0,_.Yf)(i,!1,e.emissionDimmingPass),depthTest:(0,_.mt)(i),depthWrite:(0,_.z5)(e),colorWrite:I.kn,stencilWrite:n?F.v0:null,stencilTest:n?t?F.Ax:F.cP:null,polygonOffset:(0,E.T)(e)})}initializePipeline(e){if(e.occluder){const{hasOccludees:t}=e;this._occluderPipelineTransparent=(0,I.Ey)({blending:I.T8,polygonOffset:(0,E.T)(e),depthTest:F.sf,depthWrite:null,colorWrite:I.kn,stencilWrite:null,stencilTest:t?F.Q0:null}),this._occluderPipelineOpaque=(0,I.Ey)({blending:I.T8,polygonOffset:(0,E.T)(e),depthTest:t?F.sf:F.m,depthWrite:null,colorWrite:I.kn,stencilWrite:t?F.r8:null,stencilTest:t?F.iB:null}),this._occluderPipelineMaskWrite=(0,I.Ey)({blending:null,polygonOffset:(0,E.T)(e),depthTest:F.m,depthWrite:null,colorWrite:null,stencilWrite:t?F.v0:null,stencilTest:t?F.Ax:null})}return this._occludeePipeline=this._makePipelineState(e,!0),this._makePipelineState(e,!1)}getPipeline(e,t,i){if(i)return this._occludeePipeline;switch(e.occluder){case 11:return this._occluderPipelineTransparent??super.getPipeline(e,t,i);case 10:return this._occluderPipelineOpaque??super.getPipeline(e,t,i);default:e.occluder;case void 0:case null:return this._occluderPipelineMaskWrite??super.getPipeline(e,t,i)}}};V=(0,w.Cg)([(0,L.$K)("esri.views.3d.webgl-engine.shaders.RibbonLineTechnique")],V);var H=i(47268),M=i(76221);class N extends S.i{constructor(e,t){super(e,k),this.produces=new Map([[2,e=>(0,m.Ex)(e)||(0,m._o)(e)&&8===this.parameters.renderOccluded],[3,e=>(0,m.eh)(e)],[10,e=>(0,m.gr)(e)&&8===this.parameters.renderOccluded],[11,e=>(0,m.gr)(e)&&8===this.parameters.renderOccluded],[4,e=>(0,m._o)(e)&&this.parameters.writeDepth&&8!==this.parameters.renderOccluded],[8,e=>(0,m._o)(e)&&!this.parameters.writeDepth&&8!==this.parameters.renderOccluded],[18,e=>(0,m.i3)(e)]]),this._configuration=new H.x(t)}updateConfiguration(e){super.updateConfiguration(e);const t=18===e.slot,i=null!=this.parameters.stipplePattern&&null!=this.parameters.stippleTexture&&10!==e.output,n=i&&t&&this.parameters.isImagePattern();this._configuration.draped=t,this._configuration.polygonOffset=this.parameters.polygonOffset,this._configuration.stippleEnabled=i,this._configuration.stippleOffColorEnabled=i&&null!=this.parameters.stippleOffColor,this._configuration.stipplePreferContinuous=i&&this.parameters.stipplePreferContinuous,this._configuration.numJoinSubdivisions=U(this.parameters.join,i),this._configuration.hasSlicePlane=this.parameters.hasSlicePlane,this._configuration.roundJoins="round"===this.parameters.join,this._configuration.capType=this.parameters.cap,this._configuration.applyMarkerOffset=null!=this.parameters.markerParameters&&function(e){return 1===e.anchor&&e.hideOnShortSegments&&"begin-end"===e.placement&&e.worldSpace}(this.parameters.markerParameters),this._configuration.polygonOffsetIndex=this.parameters.polygonOffsetIndex,this._configuration.writeDepth=this.parameters.writeDepth,this._configuration.hasVVSize=this.parameters.hasVVSize,this._configuration.hasVVColor=this.parameters.hasVVColor,this._configuration.hasVVOpacity=this.parameters.hasVVOpacity,this._configuration.innerColorEnabled=this.parameters.innerWidth>0&&null!=this.parameters.innerColor,this._configuration.falloffEnabled=this.parameters.falloff>0,this._configuration.hasOccludees=e.hasOccludees,this._configuration.occluder=8===this.parameters.renderOccluded,this._configuration.wireframe=this.parameters.wireframe,this._configuration.animation=this.parameters.animation,this._configuration.emissionSource=this.emissions?1:0,this._configuration.hasScreenSizePerspective=!!this.parameters.screenSizePerspective&&!n,this._configuration.worldSizedImagePattern=n}get visible(){return this.parameters.color[3]>=M.Q||null!=this.parameters.stipplePattern&&(this.parameters.stippleOffColor?.[3]??0)>M.Q}get emissions(){return this.parameters.emissiveStrength>0?8!==this.parameters.renderOccluded?2:1:0}setParameters(e,t){e.animation=this.parameters.animation,super.setParameters(e,t)}intersectDraped({attributes:e,screenToWorldRatio:t},i,n,a,o){if(!i.options.selectionMode)return;const s=e.get("size");let l=this.parameters.width;if(this.parameters.vvSize){const t=e.get("sizeFeatureAttribute").data[0];Number.isNaN(t)?l*=this.parameters.vvSize.fallback[0]:l*=(0,r.qE)(this.parameters.vvSize.offset[0]+t*this.parameters.vvSize.factor[0],this.parameters.vvSize.minSize[0],this.parameters.vvSize.maxSize[0])}else s&&(l*=s.data[0]);const c=n[0],d=n[1],p=(l/2+4)*t;let h=Number.MAX_VALUE,f=0;const u=e.get("position").data,m=J(this.parameters,e)?u.length-2:u.length-5;for(let e=0;e<m;e+=3){const t=u[e],i=u[e+1],n=(e+3)%u.length,a=c-t,o=d-i,s=u[n]-t,l=u[n+1]-i,p=(0,r.qE)((s*a+l*o)/(s*s+l*l),0,1),m=s*p-a,v=l*p-o,g=m*m+v*v;g<h&&(h=g,f=e/3)}h<p*p&&a(o.distance,o.renderDistance,o.normal,f)}intersect(e,t,i,a,o,c){const{options:d,camera:p,rayBegin:h,rayEnd:m}=i;if(!d.selectionMode||!e.visible||!p)return;if(!(0,y.zH)(t))return void n.A.getLogger("esri.views.3d.webgl-engine.materials.RibbonLineMaterial").error("intersection assumes a translation-only matrix");const v=e.attributes,g=v.get("position").data;let S=this.parameters.width;if(this.parameters.vvSize){const e=v.get("sizeFeatureAttribute").data[0];Number.isNaN(e)||(S*=(0,r.qE)(this.parameters.vvSize.offset[0]+e*this.parameters.vvSize.factor[0],this.parameters.vvSize.minSize[0],this.parameters.vvSize.maxSize[0]))}else v.has("size")&&(S*=v.get("size").data[0]);const x=te;(0,s.C)(x,i.point);const b=S*p.pixelRatio,C=4*p.pixelRatio,D=b/2+C;(0,l.hZ)(he[0],x[0]-D,x[1]+D,0),(0,l.hZ)(he[1],x[0]+D,x[1]+D,0),(0,l.hZ)(he[2],x[0]+D,x[1]-D,0),(0,l.hZ)(he[3],x[0]-D,x[1]-D,0);for(let e=0;e<4;e++)if(!p.unprojectFromRenderScreen(he[e],fe[e]))return;(0,u.Cr)(p.eye,fe[0],fe[1],ue),(0,u.Cr)(p.eye,fe[1],fe[2],me),(0,u.Cr)(p.eye,fe[2],fe[3],ve),(0,u.Cr)(p.eye,fe[3],fe[0],ge);let T=Number.MAX_VALUE,z=0;const P=J(this.parameters,v)?g.length-2:g.length-5;for(let e=0;e<P;e+=3){q[0]=g[e]+t[12],q[1]=g[e+1]+t[13],q[2]=g[e+2]+t[14];const i=(e+3)%g.length;if(G[0]=g[i]+t[12],G[1]=g[i+1]+t[13],G[2]=g[i+2]+t[14],(0,u.mN)(ue,q)<0&&(0,u.mN)(ue,G)<0||(0,u.mN)(me,q)<0&&(0,u.mN)(me,G)<0||(0,u.mN)(ve,q)<0&&(0,u.mN)(ve,G)<0||(0,u.mN)(ge,q)<0&&(0,u.mN)(ge,G)<0)continue;const n=p.projectToRenderScreen(q,ie),r=p.projectToRenderScreen(G,ne);if(null==n||null==r)continue;if(n[2]<0&&r[2]>0){(0,l.Re)(K,q,G);const e=p.frustum,t=-(0,u.mN)(e[4],q)/(0,l.Om)(K,(0,u.Qj)(e[4]));if((0,l.hs)(K,K,t),(0,l.WQ)(q,q,K),!p.projectToRenderScreen(q,n))continue}else if(n[2]>0&&r[2]<0){(0,l.Re)(K,G,q);const e=p.frustum,t=-(0,u.mN)(e[4],G)/(0,l.Om)(K,(0,u.Qj)(e[4]));if((0,l.hs)(K,K,t),(0,l.WQ)(G,G,K),!p.projectToRenderScreen(G,r))continue}else if(n[2]<0&&r[2]<0)continue;n[2]=0,r[2]=0;const a=(0,f.Cr)(n,r,oe),o=(0,f.kb)(a,x);if(!(o>=T)){if(this.parameters.screenSizePerspective){const e=this.computeScreenSizePerspectiveWidth(a,q,G,x,p,S,C);if(o>=e*e)continue}T=o,(0,l.C)(re,q),(0,l.C)(ae,G),z=e/3}}if(T<D*D){let e=Number.MAX_VALUE;if((0,f.ld)((0,f.Cr)(re,ae,oe),(0,f.Cr)(h,m,se),ee)){(0,l.Re)(ee,ee,h);const t=(0,l.Bw)(ee);(0,l.hs)(ee,ee,1/t),e=t/(0,l.Io)(h,m)}c(e,e,ee,z)}}createBufferWriter(){return new B(P(this.parameters),this.parameters)}createGLMaterial(e){return new j(e)}validateParameters(e){"miter"!==e.join&&(e.miterLimit=0),null!=e.markerParameters&&(e.markerScale=e.markerParameters.width/e.width)}update(e){return!!this.parameters.hasAnimation&&(this.setParameters({timeElapsed:(0,o.y)(e.time)},!1),0!==e.dt)}computeScreenSizePerspectiveWidth(e,t,i,n,r,a,o){const s=(0,f.G1)(e,n);(0,l.Cc)(Q,t,i,s),(0,l.Z0)(Y,Q,r.viewMatrix);const c=(0,l.Bw)(Y),d=this.computeCameraAbsCosAngle(Q,r,this._configuration.spherical);return Z.update(d,c,this.parameters.screenSizePerspective,this.parameters.screenSizePerspectiveMinPixelReferenceSize),Z.apply(a)*r.pixelRatio/2+o}computeCameraAbsCosAngle(e,t,i){return i?(0,l.S8)(ee,e):(0,l.hZ)(ee,0,0,1),(0,l.Re)(X,e,t.eye),(0,l.S8)(X,X),Math.abs((0,l.Om)(ee,X))}}class j extends g.A{constructor(){super(...arguments),this._stipplePattern=null}dispose(){super.dispose(),this._stippleTextures?.release(this._stipplePattern),this._stipplePattern=null}beginSlot(e){const{stipplePattern:t}=this._material.parameters;return this._stipplePattern!==t&&(this._material.setParameters({stippleTexture:this._stippleTextures.swap(t,this._stipplePattern)}),this._stipplePattern=t),this.getTechnique(V,e)}}class k extends C.S{constructor(){super(...arguments),this._width=0,this.color=p.Un,this.join="miter",this.cap=0,this.miterLimit=5,this.writeDepth=!0,this.polygonOffset=0,this.polygonOffsetIndex=0,this.stippleTexture=null,this.stipplePreferContinuous=!0,this.markerParameters=null,this.markerScale=1,this.hasSlicePlane=!1,this.vvFastUpdate=!1,this.isClosed=!1,this.falloff=0,this.innerWidth=0,this.wireframe=!1,this.timeElapsed=(0,o.Kp)(0),this.animation=0,this.animationSpeed=1,this.trailLength=1,this.startTime=(0,o.Kp)(0),this.endTime=(0,o.Kp)(1/0),this.emissiveStrength=0}get width(){return this.isImagePattern()?this.stipplePattern.width:this._width}set width(e){this._width=e}get transparent(){return this.color[3]<1||this.hasAnimation||null!=this.stipplePattern&&(this.stippleOffColor?.[3]??0)<1}get hasAnimation(){return 0!==this.animation}isImagePattern(){return(0,b.sL)(this.stipplePattern)&&null!=this.stippleTexture}}class B{constructor(e,t){this.layout=e,this._parameters=t,this.numJoinSubdivisions=U(this._parameters.join,null!=this._parameters.stipplePattern)}_isClosed(e){return J(this._parameters,e)}allocate(e){return this.layout.createBuffer(e)}elementCount(e){const t=e.get("position").indices.length/2+1,i=this._isClosed(e);let n=i?2:4;return n+=((i?t:t-1)-(i?0:1))*(2*this.numJoinSubdivisions+4),n+=2,this._parameters.wireframe&&(n=2+4*(n-2)),n}write(e,t,i,n,r){if(null==r)return;const{buffer:a,offset:o}=r,s=this.layout,c=i.get("position"),p=c.indices,f=c.data.length/3,u=i.get("distanceToStart")?.data;p&&p.length!==2*(f-1)&&console.warn("RibbonLineMaterial does not support indices");const m=s.fields.has("sizeFeatureAttribute");let g=1,S=null;if(m){const e=i.get("sizeFeatureAttribute");1===e.data.length?g=e.data[0]:S=e.data}else g=i.get("size")?.data[0]??1;let x=[1,1,1,1],y=0,b=null;const C=s.fields.has("colorFeatureAttribute");if(C){const e=i.get("colorFeatureAttribute");1===e.data.length?y=e.data[0]:b=e.data}else x=i.get("color")?.data??x;const T=i.get("timeStamps")?.data,z=T&&s.fields.has("timeStamps"),P=s.fields.has("opacityFeatureAttribute");let w=0,L=null;if(P){const e=i.get("opacityFeatureAttribute");1===e.data.length?w=e.data[0]:L=e.data}const O=new Float32Array(a.buffer),R=(0,h.Bg)(a.buffer),W=new Uint8Array(a.buffer),_=s.stride/4;let F=o*_;const E=F;let A=0;const I=u?(e,t,i)=>A=u[i]:(e,t,i)=>A+=(0,l.Io)(e,t),V=O.BYTES_PER_ELEMENT/R.BYTES_PER_ELEMENT,H=4/V,M=(0,v.E)(),N=(e,t,i,r,a,o,s,l)=>{O[F++]=t[0],O[F++]=t[1],O[F++]=t[2],(0,D.Wu)(e,t,R,F*V),F+=H,(0,D.Wu)(i,t,R,F*V),F+=H,O[F++]=l;let c=F*V;if(R[c++]=a,R[c++]=o,F=Math.ceil(c/V),C)O[F]=b?.[s]??y;else{const e=Math.min(4*s,x.length-4),t=4*F;W[t]=255*x[e],W[t+1]=255*x[e+1],W[t+2]=255*x[e+2],W[t+3]=255*x[e+3]}if(F++,O[F++]=S?.[s]??g,P&&(O[F++]=L?.[s]??w),M){let e=4*F;n?(W[e++]=n[0],W[e++]=n[1],W[e++]=n[2],W[e++]=n[3]):(W[e++]=0,W[e++]=0,W[e++]=0,W[e++]=0),F=Math.ceil(.25*e)}z&&(c=F*V,R[c++]=r[0],R[c++]=r[1],R[c++]=r[2],R[c++]=r[3],F=Math.ceil(c/V))};F+=_,(0,l.hZ)(ce,c.data[0],c.data[1],c.data[2]),z&&(0,d.hZ)(pe,T[0],T[1],T[2],T[3]),e&&(0,l.Z0)(ce,ce,e);const j=this._isClosed(i);if(j){const t=c.data.length-3;(0,l.hZ)(le,c.data[t],c.data[t+1],c.data[t+2]),e&&(0,l.Z0)(le,le,e)}else(0,l.hZ)(de,c.data[3],c.data[4],c.data[5]),e&&(0,l.Z0)(de,de,e),N(ce,ce,de,pe,1,-4,0,0),N(ce,ce,de,pe,1,4,0,0),(0,l.C)(le,ce),(0,l.C)(ce,de),z&&(0,d.hZ)(pe,T[4],T[5],T[6],T[7]);const k=j?0:1,B=j?f:f-1;for(let t=k;t<B;t++){const i=(t+1)%f*3;(0,l.hZ)(de,c.data[i],c.data[i+1],c.data[i+2]),e&&(0,l.Z0)(de,de,e),I(le,ce,t),N(le,ce,de,pe,0,-1,t,A),N(le,ce,de,pe,0,1,t,A);const n=this.numJoinSubdivisions;for(let e=0;e<n;++e){const i=(e+1)/(n+1);N(le,ce,de,pe,i,-1,t,A),N(le,ce,de,pe,i,1,t,A)}if(N(le,ce,de,pe,1,-2,t,A),N(le,ce,de,pe,1,2,t,A),(0,l.C)(le,ce),(0,l.C)(ce,de),z){const e=(t+1)%f*4;(0,d.hZ)(pe,T[e],T[e+1],T[e+2],T[e+3])}}j?((0,l.hZ)(de,c.data[3],c.data[4],c.data[5]),e&&(0,l.Z0)(de,de,e),A=I(le,ce,B),N(le,ce,de,pe,0,-1,k,A),N(le,ce,de,pe,0,1,k,A)):(A=I(le,ce,B),N(le,ce,ce,pe,0,-5,B,A),N(le,ce,ce,pe,0,5,B,A)),$(O,E+_,O,E,_),F=$(O,F-_,O,F,_),this._parameters.wireframe&&this._addWireframeVertices(a,E,F,_)}_addWireframeVertices(e,t,i,n){const r=new Float32Array(e.buffer,i*Float32Array.BYTES_PER_ELEMENT),a=new Float32Array(e.buffer,t*Float32Array.BYTES_PER_ELEMENT,i-t);let o=0;const s=e=>o=$(a,e,r,o,n);for(let e=0;e<a.length-1;e+=2*n)s(e),s(e+2*n),s(e+1*n),s(e+2*n),s(e+1*n),s(e+3*n)}}function $(e,t,i,n,r){for(let a=0;a<r;a++)i[n++]=e[t++];return n}function J(e,t){return!!e.isClosed&&t.get("position").indices.length>2}function U(e,t){const i=t?1:0;switch(e){case"miter":case"bevel":return i;case"round":return 1+i}}const Z=new x.PS,q=(0,c.vt)(),G=(0,c.vt)(),Q=(0,c.vt)(),Y=(0,c.vt)(),X=(0,c.vt)(),K=(0,c.vt)(),ee=(0,c.vt)(),te=(0,c.vt)(),ie=(0,a.r_)(),ne=(0,a.r_)(),re=(0,c.vt)(),ae=(0,c.vt)(),oe=(0,f.vt)(),se=(0,f.vt)(),le=(0,c.vt)(),ce=(0,c.vt)(),de=(0,c.vt)(),pe=(0,p.vt)(),he=[(0,a.r_)(),(0,a.r_)(),(0,a.r_)(),(0,a.r_)()],fe=[(0,c.vt)(),(0,c.vt)(),(0,c.vt)(),(0,c.vt)()],ue=(0,u.vt)(),me=(0,u.vt)(),ve=(0,u.vt)(),ge=(0,u.vt)()},51310(e,t,i){i.d(t,{Xq:()=>c,sL:()=>s,wk:()=>l});var n=i(1874);const r={dash:[4,3],dot:[1,3],"long-dash":[8,3],"short-dash":[4,1],"short-dot":[1,1]},a={dash:r.dash,"dash-dot":[...r.dash,...r.dot],dot:r.dot,"long-dash":r["long-dash"],"long-dash-dot":[...r["long-dash"],...r.dot],"long-dash-dot-dot":[...r["long-dash"],...r.dot,...r.dot],none:null,"short-dash":r["short-dash"],"short-dash-dot":[...r["short-dash"],...r["short-dot"]],"short-dash-dot-dot":[...r["short-dash"],...r["short-dot"],...r["short-dot"]],"short-dot":r["short-dot"],solid:null};class o{constructor(e,t,i){this.image=e,this.width=t,this.length=i,this.uuid=(0,n.lk)()}}function s(e){return null!=e&&"image"in e}function l(e){return{pattern:[e,e],pixelRatio:2}}function c(e){switch(e?.type){case"style":return function(e){return null!=e?function(e){return null==e?e:{pattern:e.slice(),pixelRatio:8}}(a[e]):null}(e.style);case"image":return new o(e.image,e.width,e.length);case void 0:case null:return null}return null}},64064(e,t,i){i.d(t,{Q:()=>p});var n=i(53334),r=i(56560),a=i(67900);const o=(0,a.Kp)(1),s=(0,a.Kp)(1);var l=i(66579),c=i(19635),d=i(62462);function p(e,t){const{hasAnimation:i,animation:r}=t;if(!i)return;const{attributes:a,varyings:p,vertex:f,fragment:u}=e;a.add("timeStamps","vec4"),p.add("vTimeStamp","float"),p.add("vFirstTime","float"),p.add("vLastTime","float"),p.add("vTransitionType","float"),f.main.add(d.H`vTimeStamp = timeStamps.x;
vFirstTime = timeStamps.y;
vLastTime = timeStamps.z;
vTransitionType = timeStamps.w;`),3===r&&u.constants.add("decayRate","float",2.3),u.code.add(d.H`
    float getTrailOpacity(float x) {
      if (x < 0.0) {
        return 0.0;
      }

      ${function(e){switch(e){case 2:return"return x >= 0.0 && x <= 1.0 ? 1.0 : 0.0;";case 3:return"float cutOff = exp(-decayRate);\n        return (exp(-decayRate * x) - cutOff) / (1.0 - cutOff);";default:return"return 1.0;"}}(r)}
    }`),u.uniforms.add(new c.m("timeElapsed",e=>e.timeElapsed),new c.m("trailLength",e=>e.trailLength),new c.m("speed",e=>e.animationSpeed),new l.G("startEndTime",e=>(0,n.hZ)(h,e.startTime,e.endTime))),u.constants.add("fadeInTime","float",s),u.constants.add("fadeOutTime","float",o),u.constants.add("incomingTransition","int",0),u.constants.add("outgoingTransition","int",2),u.code.add(d.H`float fadeIn(float x) {
return smoothstep(0.0, fadeInTime, x);
}
float fadeOut(float x) {
return isinf(fadeOutTime) ? 1.0 : smoothstep(fadeOutTime, 0.0, x);
}
void updateAlphaIf(inout float alpha, bool condition, float newAlpha) {
alpha = condition ? min(alpha, newAlpha) : alpha;
}
vec4 animate(vec4 color) {
float startTime = startEndTime[0];
float endTime = startEndTime[1];
float totalTime = vLastTime - vFirstTime;
float actualFadeOutTime = min(fadeOutTime * speed, trailLength);
float longStreamlineThreshold = (fadeInTime + 1.0) * speed + actualFadeOutTime;
bool longStreamline = totalTime > longStreamlineThreshold;
float totalTimeWithFadeOut = longStreamline && actualFadeOutTime != trailLength ? totalTime : totalTime + actualFadeOutTime;
float fadeOutStartTime = longStreamline ? totalTime - actualFadeOutTime : totalTime;
float originTime =  -vFirstTime;
float actualEndTime = int(vTransitionType) == outgoingTransition ? min(endTime, startTime + vLastTime / speed) : endTime;
vec4 animatedColor = color;
if (speed == 0.0) {
float alpha = getTrailOpacity((totalTimeWithFadeOut - (vTimeStamp - vFirstTime)) / trailLength);
updateAlphaIf(alpha, !isinf(actualEndTime), fadeOut(timeElapsed - actualEndTime));
updateAlphaIf(alpha, true, fadeIn(timeElapsed - startTime));
animatedColor.a *= alpha;
return animatedColor;
}
float relativeStartTime = mod(startTime, totalTimeWithFadeOut);
float shiftedTimeElapsed = timeElapsed - relativeStartTime + originTime;
float headRelativeToFirst = mod(shiftedTimeElapsed * speed, totalTimeWithFadeOut);
float vRelativeToHead = headRelativeToFirst - originTime - vTimeStamp;
float vAbsoluteTime = timeElapsed - vRelativeToHead / speed;
if (startTime > timeElapsed) {
return vec4(0.0);
}
float alpha = getTrailOpacity(vRelativeToHead / trailLength);
updateAlphaIf(alpha, true, fadeIn(timeElapsed - startTime));
updateAlphaIf(alpha, !isinf(actualEndTime), fadeOut(timeElapsed - actualEndTime));
updateAlphaIf(alpha, int(vTransitionType) != incomingTransition, step(startTime, vAbsoluteTime));
updateAlphaIf(alpha, headRelativeToFirst > fadeOutStartTime, fadeOut((headRelativeToFirst - fadeOutStartTime) / speed));
alpha *= fadeIn(vTimeStamp - vFirstTime);
animatedColor.a *= alpha;
return animatedColor;
}`)}const h=(0,r.vt)()},47268(e,t,i){i.d(t,{x:()=>o});var n=i(31635),r=i(67069),a=i(36638);class o extends a.L{constructor(e){super(),this.spherical=e,this.capType=0,this.emissionSource=0,this.animation=2,this.polygonOffsetIndex=0,this.writeDepth=!1,this.draped=!1,this.stippleEnabled=!1,this.stippleOffColorEnabled=!1,this.stipplePreferContinuous=!0,this.numJoinSubdivisions=1,this.roundJoins=!1,this.applyMarkerOffset=!1,this.hasVVSize=!1,this.hasVVColor=!1,this.hasVVOpacity=!1,this.falloffEnabled=!1,this.innerColorEnabled=!1,this.hasOccludees=!1,this.occluder=!1,this.wireframe=!1,this.discardInvisibleFragments=!1,this.hasScreenSizePerspective=!1,this.worldSizedImagePattern=!1,this.textureCoordinateType=0,this.hasVVInstancing=!1,this.hasSliceTranslatedView=!0,this.overlayEnabled=!1,this.snowCover=!1}get hasAnimation(){return 0!==this.animation}}(0,n.Cg)([(0,r.W)({count:3})],o.prototype,"capType",void 0),(0,n.Cg)([(0,r.W)({count:8})],o.prototype,"emissionSource",void 0),(0,n.Cg)([(0,r.W)({count:4})],o.prototype,"animation",void 0),(0,n.Cg)([(0,r.W)({count:16})],o.prototype,"polygonOffsetIndex",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"writeDepth",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"draped",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"stippleEnabled",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"stippleOffColorEnabled",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"stipplePreferContinuous",void 0),(0,n.Cg)([(0,r.W)({count:8})],o.prototype,"numJoinSubdivisions",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"roundJoins",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"applyMarkerOffset",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"hasVVSize",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"hasVVColor",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"hasVVOpacity",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"falloffEnabled",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"innerColorEnabled",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"hasOccludees",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"occluder",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"wireframe",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"discardInvisibleFragments",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"hasScreenSizePerspective",void 0),(0,n.Cg)([(0,r.W)()],o.prototype,"worldSizedImagePattern",void 0)}}]);