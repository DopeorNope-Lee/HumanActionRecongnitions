"""
@Author : Seungyoo Lee (git-hub : @dopeornope_lee) & Kyujin Han(git-hub : kyujinHan)
@ Date : 2023.04.11
@ Description : train and evaluate new structure of Transformer model.
"""

'''
Step0) Import module
'''
from keras.callbacks import EarlyStopping, ReduceLROnPlateau
import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import tensorflow as tf
import tensorflow_addons as tfa
from tensorflow.keras.callbacks import EarlyStopping
from tensorflow import keras
from tensorflow.keras import layers
from tqdm import tqdm
from tensorflow.python.client import device_lib

# check GPU option
print(device_lib.list_local_devices())
print(tf.__version__)
print(tf.test.is_gpu_available())


'''
Step1) Model function
'''
def transformer_encoder(inputs, head_size, num_heads, ff_dim, dropout=0):
    # Normalization and Attention
    x = layers.MultiHeadAttention(
        key_dim=head_size, num_heads=num_heads, dropout=dropout
    )(inputs, inputs)
    x = layers.Dropout(dropout)(x)
    x = layers.LayerNormalization(epsilon=1e-6)(x)
    res = x + inputs
    
    x = layers.Dense(128, activation='relu')(res) 
    x = layers.Dropout(dropout)(x)
    x = layers.Dense(inputs.shape[-1])(x)
    x = layers.LayerNormalization(epsilon=1e-6)(x)
    return x + res

# high-frequenct positional encoding
def encode_position(x):

    positions = [x]
    for i in range(10):
        for fn in [tf.sin, tf.cos]:
            positions.append(fn(2.0 ** i * x))
    
    position = tf.concat(positions, axis=-1)
    
    return position

# build model
def build_model(
    input_shape,
    head_size,
    num_heads,
    ff_dim,
    num_transformer_blocks,
    mlp_units,
    dropout=0,
    mlp_dropout=0,
    n_classes=5):
    
    inputs = keras.Input(shape=input_shape,sparse=False)
    x = inputs
    # embedding
    x = encode_position(x)
    #print(x.shape)
    
    for _ in range(num_transformer_blocks):
        x = transformer_encoder(x, head_size, num_heads, ff_dim, dropout)

    x = layers.GlobalAveragePooling1D(data_format="channels_first")(x)
    
    res_x=x
    for dim in mlp_units:
        x = layers.Dense(dim, activation="relu")(x)
        x = layers.Dropout(mlp_dropout)(x)
    
    x=x+res_x

    x = layers.Dense(dim, activation="relu")(x)
    outputs = layers.Dense(n_classes, activation="softmax")(x)
    return keras.Model(inputs, outputs)


'''
Step2) Main function(training function)
'''
def main():

    # get dataset
    x_train=np.load('./data/x_train.npy')
    x_valid=np.load('./data/x_valid.npy')
    x_test=np.load('./data/x_test.npy')
    y_train=np.load('./data/y_train.npy', allow_pickle=True)
    y_valid=np.load('./data/y_valid.npy', allow_pickle=True)
    y_test=np.load('./data/y_test.npy', allow_pickle=True)
    
    print("x shape:",x_train.shape)
    print("y shape:",y_train.shape)

    input_shape = x_train.shape[1:]

    # model build
    model = build_model(
        input_shape,
        head_size=256,
        num_heads=8,
        ff_dim=63,
        num_transformer_blocks=6,
        mlp_units=[128,80],
        mlp_dropout=0.1,
        dropout=0.1,
        n_classes=5)

    # earlystopping and ReduceLROnPlateau
    early_stop=EarlyStopping(patience=10, restore_best_weights=True)
    RLR=ReduceLROnPlateau(monitors='val_accuracy',patience=5,verbose=2,factor=0.5,min_lr=1e-6)
    callbacks = [early_stop, RLR]

    model.compile(
    loss=tfa.losses.SigmoidFocalCrossEntropy(),
    #loss=tf.keras.losses.CategoricalCrossentropy(),
    optimizer=keras.optimizers.Adam(learning_rate=5e-4),
    metrics=["accuracy",tf.keras.metrics.Precision() ,tf.keras.metrics.Recall()] )

    # model training
    model.fit(
    x_train,
    y_train,
    validation_data=(x_valid,y_valid),
    batch_size=128,
    epochs=150,
    callbacks=callbacks)

    # save and evaluation
    model.save('./pretrained')
    print("====================evaluating====================")
    model.evaluate(x_test,y_test)

# running code
if __name__ == "__main__":
    main()
