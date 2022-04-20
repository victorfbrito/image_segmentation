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
        float mn = min(min(r,g),b);
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
      
      //Detect solider clothes
        if (green(aux.pixels[pos]) != 0 && green(aux.pixels[pos]) < 40 && x < 250 && x > 50)
         aux.pixels[pos] = color(255);
        else if (blue(aux.pixels[pos]) > 0 && x < 250 && x > 50)
          aux.pixels[pos] = color(255);
        else if (green(aux.pixels[pos]) > 50 && x < 180 && x > 90 && y < 200 && y > 102)
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
