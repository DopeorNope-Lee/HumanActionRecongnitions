# SS-Former(Sensor Series Transformer)
> Make transformer encoder with high-frequency positional encoding and MLP decoder.
![ss-former_overview](https://user-images.githubusercontent.com/98331298/231897843-e5542980-6b6d-4de3-87ee-fc77ab7a225c.jpg)
![decoder](https://user-images.githubusercontent.com/98331298/231897806-3496fde7-fd5b-4dfa-899e-7f3e52d029c5.jpg)

# Introduction



# Dataset


# Quick Start


# Performance 
- About User_01 Performance.
  
| Variable | Accuracy | F1-score | Precision | Recall | 
| ------------- | ------------- | ------------- | ------------- | ------------- |
| `mAcc` | 0.9263 | 0.9156 | 0.9827 | 0.8570 |
| `mGyr` | 0.9045 | 0.8818 | 0.9744 | 0.8052 |
| `mMag` | 0.8945 | 0.8918 | 0.9718 | 0.8239 |
| `mAcc+mGyr+mMag` | 0.9139 | 0.9059 | 0.9741 | 0.8466 |

- The impact of the high-frequency positional encoding.
   
| φx | Accuracy | F1-score | Precision | Recall | 
| ------------- | ------------- | ------------- | ------------- | ------------- |
| `w/o φx` | 0.8801 | 0.8694 | 0.9498 | 0.8016 |
| `w/ φx` | 0.9263 | 0.9156 | 0.9827 | 0.8570 |
