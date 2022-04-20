import java.util.ArrayList;
import java.util.Collections;

void setup() {
  size(267, 400);
  noLoop();
}
void draw() {
  PImage img = loadImage("original_image.jpg");
  PImage original_segmented_img = loadImage("original_segmented_image.jpg");
  PImage aux = createImage(img.width, img.height, RGB);
  
  // Filtro de escala de cinza
  for(int y=0; y < img.height; y++) {
    for(int x=0; x < img.width; x++) {
       int pos = y*img.width + x;
       float media = (red(img.pixels[pos]) +
         green(img.pixels[pos]) + blue(img.pixels[pos]))/3;
       aux.pixels[pos] = color(media);
    }
  }
  
  // Filtro de Média com Janela Deslizante
  for(int y=0; y < img.height; y++) {
    for(int x=0; x < img.width; x++) {
       int pos = y*img.width + x;
       int jan = 2, qtde = 0; 
       float media_r = 0;
       float media_g = 0;
       float media_b = 0;

       for(int i = jan*(-1); i <= jan; i++) {
         for (int j = jan*(-1); j <= jan; j++) {
           int nx = x + j;
           int ny = y + i;
           
           if(ny >= 0 && ny < img.height &&
              nx >= 0 && nx < img.width) {
                int pos_aux = ny*img.width + nx;
                media_r += red(img.pixels[pos_aux]);
                media_g += green(img.pixels[pos_aux]);
                media_b += blue(img.pixels[pos_aux]);
                qtde++;
              }
         }
       }
       media_r = media_r / qtde;
       media_g = media_g / qtde;
       media_b = media_b / qtde;
       aux.pixels[pos] = color(media_r,media_g,media_b);
    }
  }
  
  // Filtro de MaxRGB
  for(int y=0; y < img.height; y++) {
    for(int x=0; x < img.width; x++) {
       int pos = y*img.width + x;
        float r = red(aux.pixels[pos]);
        float g = green(aux.pixels[pos]);
        float b = blue(aux.pixels[pos]);
        float mx = max(max(r,g),b);
        if ( r < mx) r = 0; 
        if ( g < mx) g = 0; 
        if ( b < mx) b = 0; 
        
        aux.pixels[pos] = color(r,g,b);
    }
  }
  
  // Filtro de Limiarização
  for(int y=0; y < img.height; y++) {
    for(int x=0; x < img.width; x++) {
       int pos = y*img.width + x;
       float media = (red(img.pixels[pos]) +
         green(img.pixels[pos]) + blue(img.pixels[pos]))/3;
       
      //Detect body 
      if(red(aux.pixels[pos]) > 0  && y < 220 && x > 50 && x < 220) 
        aux.pixels[pos] = color(255);
      //Detect left leg
      else if(red(aux.pixels[pos]) > 0 && media > 80 && y > 220 && y < 320 && x > 100 && x < 200) 
        aux.pixels[pos] = color(255);
      //Detect pants
      else if(blue(aux.pixels[pos]) > 0 && blue(aux.pixels[pos]) < 160 && y > 140  && y < 260 && x < 205 && x > 50) 
        aux.pixels[pos] = color(255);
      else
        aux.pixels[pos] = color(0);
    }
  }
  
  // Cálculo de semelhança
 float pixel_qtd = 0;
 float equal_pixels = 0;
  for(int y=0; y < img.height; y++) {
    for(int x=0; x < img.width; x++) {
       int pos = y*img.width + x;
       pixel_qtd += 1;
       if (aux.pixels[pos] == original_segmented_img.pixels[pos])
         equal_pixels += 1;
    }
  }
  print("qtd de pixels:", pixel_qtd, "\n");
  print("equal pixels:", equal_pixels, "\n");
  print("similarity percentage:", (equal_pixels/pixel_qtd) * 100, "%");
 
  image(aux,0,0);
  save("custom_segmented_image.jpg");
}
