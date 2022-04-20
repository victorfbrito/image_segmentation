import java.util.ArrayList;
import java.util.Collections;

void setup() {
  size(300, 400);
  noLoop();
}
void draw() {
  PImage img = loadImage("original_image.jpg");
  PImage original_segmented_img = loadImage("original_segmented_image.jpg");
  PImage aux = createImage(img.width, img.height, RGB);
  PImage aux_blue = createImage(img.width, img.height, RGB);
  PImage aux_red = createImage(img.width, img.height, RGB);
  
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
       int jan = 1, qtde = 0; 
       float media_red = 0; 
       float media_blue = 0;
  
       for(int i = jan*(-1); i <= jan; i++) {
         for (int j = jan*(-1); j <= jan; j++) {
           int nx = x + j;
           int ny = y + i;
           
           if(ny >= 0 && ny < img.height &&
              nx >= 0 && nx < img.width) {
                int pos_aux = ny*img.width + nx;
                media_red += red(img.pixels[pos_aux]);
                media_blue += blue(img.pixels[pos_aux]);
                qtde++;
              }
         }
       }
       media_red = media_red / qtde;
       media_blue = media_blue / qtde;
       aux_red.pixels[pos] = color(media_red);
       aux_blue.pixels[pos] = color(media_blue);
    }
  }
  
  // Filtro de Limiarização
  for(int y=0; y < img.height; y++) {
    for(int x=0; x < img.width; x++) {
       int pos = y*img.width + x;
       float media = (red(img.pixels[pos]) +
         green(img.pixels[pos]) + blue(img.pixels[pos]))/3;
       
      //Detect head 
      if(blue(aux_blue.pixels[pos]) < 80 && y > 75 && y < 200 && x > 105 && x < 180) 
         aux.pixels[pos] = color(255);
         
      //Detect arms
      else if(red(img.pixels[pos]) > 80 && y > 240 && y < 340 && x > 30 && x < 230) 
         aux.pixels[pos] = color(255);
      
      //Detect clothes (up)
      else if (red(aux_red.pixels[pos]) < 60 && y > 175 && y < 310 && x < 245 && x > 30) 
        aux.pixels[pos] = color(255);
        
      //Detect clothes (down)
      else if (red(aux_red.pixels[pos]) < 60 && y > 310 && x < 245 && x > 55) 
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
