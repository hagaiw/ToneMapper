
varying highp vec2 TexCoordOut;
uniform sampler2D Texture;

void main(void) {
  gl_FragColor = texture2D(Texture, TexCoordOut);
  
  if (TexCoordOut.x < 0.1) {
    gl_FragColor = vec4(0.5);
  }
}