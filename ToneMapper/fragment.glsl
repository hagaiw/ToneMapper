
varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New

void main(void) {
  gl_FragColor = texture2D(Texture, TexCoordOut); // New
}