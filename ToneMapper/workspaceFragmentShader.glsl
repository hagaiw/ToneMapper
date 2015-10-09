
varying lowp vec2 TexCoordOut; // New
uniform sampler2D Texture; // New

void main(void) {
  gl_FragColor = texture2D(Texture, TexCoordOut); // New
  
  
  if (TexCoordOut.y < 0.1) {
    gl_FragColor = vec4(0.8);
  }
  
  //gl_FragColor = vec4(0.2);
}