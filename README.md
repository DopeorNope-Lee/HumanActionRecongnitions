# SS-Former(Sensor Series Transformer)
> Make transformer encoder with high-frequency positional encoding and residual MLP decoder.  
![ss-former_overview](https://user-images.githubusercontent.com/98331298/231897843-e5542980-6b6d-4de3-87ee-fc77ab7a225c.jpg)  
> SS-Former Overview    
    
![decoder](https://user-images.githubusercontent.com/98331298/231897806-3496fde7-fd5b-4dfa-899e-7f3e52d029c5.jpg)  
> MLP-Decoder of SS-Former  
  
# Introduction
[AI factory](https://aifactory.space/competition/detail/2234)
  
# Dataset
In this project, we use [ETRI](https://nanum.etri.re.kr/share/schung1/ETRILifelogDataset2020?lang=ko_KR) dataset.
```
We use 2018 and 2019 ETRI life log dataset.
There are 50 users, and total 5 activity classes.
```  
  
# Data preprocessing (merge part)
0. If you want implement data merging, first you download 'dataset_2018.7z' files in [ETRI](https://nanum.etri.re.kr/share/schung1/ETRILifelogDataset2020?lang=ko_KR). 

1. And you some setting the 'Data_Merge_Processing.R' code.
```
For example)
1. Change setwd() function. 
2. Change the save path.
...
```

2. Implementation the R code.
    
# Quick Start
1. Download sample [dataset](). We provided user_25 dataset.
  
2. Move to the file into data folder
```
data
├── user_25.csv
└── ...
```
  
3. Implementation the 'data_preprocessing.ipynb'
```
If you want use whole variables or using another user etc, you will change among 'user_lst, var_lst, target_name'.
```
  
 4. There are exists dataset.
 ```
data
├── user_25.csv
├── X_train.npy
├── X_valid.npy
├── X_test.npy
├── Y_train.npy
├── Y_valid.npy
├── Y_test.npy
└── ...
```
  
5. Implementation 'train.py'
```
# In python terminal
$(your path)> python train.py
```
  
# Performance 
- Performance of the proposed model for human activity classification for User_01  
  
| Variable | Accuracy | F1-score | Precision | Recall | 
| ------------- | ------------- | ------------- | ------------- | ------------- |
| `mAcc(ours)` | 0.9263 | 0.9156 | 0.9827 | 0.8570 |
| `mGyr` | 0.9045 | 0.8818 | 0.9744 | 0.8052 |
| `mMag` | 0.8945 | 0.8918 | 0.9718 | 0.8239 |
| `mAcc+mGyr+mMag` | 0.9139 | 0.9059 | 0.9741 | 0.8466 |
  
- The results with and without the use of high-frequency positional encoding for User_01  
   
| φx | Accuracy | F1-score | Precision | Recall | 
| ------------- | ------------- | ------------- | ------------- | ------------- |
| `w/o φx` | 0.8801 | 0.8694 | 0.9498 | 0.8016 |
| `w/ φx` | 0.9263 | 0.9156 | 0.9827 | 0.8570 |

- Accuracy and F1-score of the proposed model for 20 randomly selected users  
   
| User_num | Accuracy | F1-score |  
| ------------- | ------------- | ------------- | 
| User_01 | 0.9263 | 0.9156 | 
| User_02 | 0.9021 | 0.xxxx | 
| User_03 | 0.9072 | 0.xxxx | 
| User_06 | 0.9250 | 0.xxxx | 
| User_14 | 0.9104 | 0.xxxx | 
| User_16 | 0.9034 | 0.xxxx | 
| User_18 | 0.9029 | 0.xxxx | 
| User_19 | 0.9053 | 0.8929 | 
| User_20 | 0.9122 | 0.xxxx | 
| User_25 | 0.9458 | 0.xxxx | 
| User_101 | 0.9201 | 0.9144 | 
| User_104 | 0.9111 | 0.8926 | 
| User_105 | 0.9435 | 0.9381 | 
| User_108 | 0.9224 | 0.8948 | 
| User_109 | 0.9431 | 0.9368 | 
| User_112 | 0.9003 | 0.8773 | 
| User_113 | 0.9610 | 0.9548 | 
| User_115 | 0.9048 | 0.8793 | 
| User_117 | 0.9229 | 0.9116 | 
| User_119 | 0.xxxx | 0.xxxx | 
