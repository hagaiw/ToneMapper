attribute vec4 Position; // 1

uniform mat4 Projection;

attribute vec2 TexCoordIn; // New
varying vec2 TexCoordOut; // New

void main(void) { // 4
  gl_Position = Projection * Position; // 6
  TexCoordOut = TexCoordIn; // New
}