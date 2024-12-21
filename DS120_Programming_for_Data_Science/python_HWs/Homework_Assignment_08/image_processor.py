from PIL import Image
import numpy as np
import matplotlib.pyplot as plt
class ImageProcessor:
    def __init__(self, path):
        image_pil = Image.open(path)        # Hints for a - how get FROM PATH TO IMAGE IN NUMPY
        image_np = np.array(image_pil)  # this will be your private attribute result,this is the image in numpy array.
        self.__image_np = image_np
    def show_image(self):
        plt.imshow(self.__image_np)
    def get_shape(self):
        return (self.__image_np.shape)
    def show_flipped_image(self):
        plt.imshow(self.__image_np[::-1])
    def show_blackwhite_image(self):
        plt.imshow(np.mean(self.__image_np, axis=2), cmap='gray', vmin=0, vmax=255)