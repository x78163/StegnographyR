rm(list = ls())
library("png")
library("colorspace")
library("magick")
library("svDialogs")

#Get file location
winDialog("ok","Choose Image File to encrypt")
fileDirectory <-  file.choose()

#Get input Image
inputImage <- image_read(fileDirectory)
imageAttributes <- image_info(inputImage)
height <- as.numeric(imageAttributes[2])
width <- as.numeric(imageAttributes[3])
imageAttributes

#Convert to PNG and Grayscale
imageGrey <- image_quantize(inputImage,colorspace = "gray")
imageGrey <- image_convert(imageGrey,format = "png")

#Save a temp file 
tmpName <- tempfile(pattern = "stegImg",fileext = ".png")
image_write(imageGrey,path = tmpName)

#read the temp file into matrix
intensityMatrix <- readPNG(tmpName)
intensityMatrix <- round(255*intensityMatrix)
image(intensityMatrix ,col = gray(0:255 / 256))

#Extract LSB
zeros = vector(mode = "numeric",length = ncol(intensityMatrix))
b1 <- zeros+1
bit1 <- NULL#LSB original
for( i in (1:nrow(x))){
  vec <- bitwAnd(x[i,],b1)#lsb
  bit1 <- rbind(bit1,vec)
}

#Get Message Input
maxLen <- (height*width)/8
plainText <- dlgInput(message = paste0("Enter Message to encypt. Max character limit = ",maxLen), default = "My Message", gui = .GUI)$res

#convert string to bitstream