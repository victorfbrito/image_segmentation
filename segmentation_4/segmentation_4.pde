import java.util.ArrayList;
import java.util.Collections;

void setup() {
  size(400, 300);
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
  
  // Filtro de Limiarização
  for(int y=0; y < img.height; y++) {
    for(int x=0; x < img.width; x++) {
       int pos = y*img.width + x;
      
      //Detect person
      if (blue(aux.pixels[pos]) < 133 && y < 170) 
        aux.pixels[pos] = color(255);
      else if (blue(aux.pixels[pos]) < 78 && y >= 170 && y < 185 && x > 100)
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
