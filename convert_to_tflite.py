import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers

# Example: simple CNN for binary classification (Fresh vs Spoiled)
model = keras.Sequential([
    layers.Conv2D(32, (3,3), activation='relu', input_shape=(128,128,3)),
    layers.MaxPooling2D(2,2),
    layers.Conv2D(64, (3,3), activation='relu'),
    layers.MaxPooling2D(2,2),
    layers.Flatten(),
    layers.Dense(128, activation='relu'),
    layers.Dense(1, activation='sigmoid')  # binary output
])

model.compile(optimizer='adam',
              loss='binary_crossentropy',
              metrics=['accuracy'])

# Train with your dataset (images of fresh vs spoiled food)
# X_train, y_train = ...
# model.fit(X_train, y_train, epochs=10, validation_split=0.2)

# Save the model
model.save("food_quality_model.h5")
import tensorflow as tf

model = tf.keras.models.load_model("food_quality_model.h5")
converter = tf.lite.TFLiteConverter.from_keras_model(model)
tflite_model = converter.convert()

with open("food_quality_model.tflite", "wb") as f:
    f.write(tflite_model)