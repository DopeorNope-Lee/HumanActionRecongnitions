################################################################################
### 데이터 기준 전처리 코드
################################################################################

# 로그 데이터 병합
library(tidyverse)
library(dplyr)
library(stringr)

# set library & dir
setwd("C:/R_base_files/dataset_2018/")
user_list <- list.files()   # 년도 유저 정보 
# 데이터 크기 이슈에 따라 년도별 데이터 저장 불가
# total_2018_data <- data.frame()   # 년도 전체 정보 / 전처리 후 데이터 셋

# 각 유저별 for 문
# 유저별 가지고 있는 폴더(일자 정보) 리스트 업
# 유저별 절대 경로 설정 및 유저별 토탈 데이터 셋 설정
user_list <- user_list[-c(1:3)]
# 유저 1번만 시행
# 원래는 1 대신 user_list
for (k in user_list) {
  user_file_dir <-paste0(getwd(), "/", k)
  user_files <- list.files(user_file_dir)
  user <- data.frame()

  # 각 유저별 for 문
  # 유저별 절대 경로 설정 및 유저별 토탈 데이터 셋 설정
  for (i in 1:length(user_files)) {
    df <- read.csv(paste0(user_file_dir,"/",user_files[i],"/",user_files[i],"_label",".csv")) # 유저의 요일별 레이블 csv 읽어오기
    user_onday_file_list <- c("mAcc", "mGyr", "mMag")
    hangyeol <- list()

    # 요일 내 변수 파일들 기준 for 문
    # 각 변수의 합을 넣을 
    for (a in 1:length(user_onday_file_list)) {       
      miner_df <- data.frame()
      # 좌표 파일 e4Acc 등
      miner_file_list <- list.files(paste0(user_file_dir,"/",user_files[i],"/",user_onday_file_list[a]))
      # 좌표 파일 내 csv 개수 기준으로 for문 전개
      for (b in 1:length(miner_file_list)) {          # 각 기록 내의 1분 단위 기록들에 대해서
        # 1분 기록
        miner_miner_df <- read.csv(paste0(user_file_dir,"/",user_files[i],"/",user_onday_file_list[a],"/",miner_file_list[b]))
        # 열 이름 추출
        miner_miner_colnames <- names(miner_miner_df)
        # 열 이름 각 측정별 이름으로 변환
        names(miner_miner_df) <- paste0(str_replace_all(paste0(user_onday_file_list[a],"_"), ".csv", ""), miner_miner_colnames)
        miner_miner_df$ts <- str_replace_all(miner_file_list[b], ".csv", "")
        miner_miner_df$ts <- as.integer(miner_miner_df$ts)
        miner_miner_df$exper <- user_files[i]
        # 좌표 파일 내 csv합치기, 최종적으로 측정별로 하루치 csv파일로 통합
        
        miner_df <- rbind(miner_df, miner_miner_df)
      }

      print("variable file is done :)")
      hangyeol[[a]] <- miner_df
    }

    df_mAcc <- as.data.frame(hangyeol[[1]])
    df_mGyr <- as.data.frame(hangyeol[[2]])
    df_mMag <- as.data.frame(hangyeol[[3]])
    
    df_mAcc %>% 
      group_by(ts) %>% summarise(n = n()) %>% ungroup() -> df_mAcc_summary
    df_mGyr %>% 
      group_by(ts) %>% summarise(n = n()) %>% ungroup() -> df_mGyr_summary
    df_mMag %>% 
      group_by(ts) %>% summarise(n = n()) %>% ungroup() -> df_mMag_summary
    
    nrow_info <- c(nrow(df_mAcc_summary), nrow(df_mGyr_summary), nrow(df_mMag_summary))
    which.min(nrow_info) -> min_info
    
    if(min_info == 1){
      unique(df_mAcc$ts) -> ts_info
      df_mGyr %>% filter(ts %in% ts_info) -> df_mGyr
      df_mMag %>% filter(ts %in% ts_info) -> df_mMag
    }else if(min_info == 2){
      unique(df_mGyr$ts) -> ts_info
      df_mAcc %>% filter(ts %in% ts_info) -> df_mAcc
      df_mMag %>% filter(ts %in% ts_info) -> df_mMag
    }else if(min_info == 3){
      unique(df_mMag$ts) -> ts_info
      df_mAcc %>% filter(ts %in% ts_info) -> df_mAcc
      df_mGyr %>% filter(ts %in% ts_info) -> df_mGyr
    }
    
    print("TS 분리 완료")
    
    new_df_mAcc <- data.frame()
    new_df_mGyr <- data.frame()
    new_df_mMag <- data.frame()
    
    for (p in ts_info) {
      df_mAcc %>% filter(ts == p) -> mini_macc
      df_mGyr %>% filter(ts == p) -> mini_mgyr
      df_mMag %>% filter(ts == p) -> mini_mmag
      
      nrow_info2 <- c(nrow(mini_macc), nrow(mini_mgyr), nrow(mini_mmag))
      which.min(nrow_info2) -> min_info2
      
      if(min_info2 == 1){
        mini_macc <- mini_macc[sample(nrow(mini_macc), nrow(mini_macc)),]
        mini_mgyr <- mini_mgyr[sample(nrow(mini_mgyr), nrow(mini_macc)),]
        mini_mmag <- mini_mmag[sample(nrow(mini_mmag), nrow(mini_macc)),]
      }else if(min_info2 == 2){
        mini_macc <- mini_macc[sample(nrow(mini_macc), nrow(mini_mgyr)),]
        mini_mgyr <- mini_mgyr[sample(nrow(mini_mgyr), nrow(mini_mgyr)),]
        mini_mmag <- mini_mmag[sample(nrow(mini_mmag), nrow(mini_mgyr)),]
      }else if(min_info2 == 3){
        mini_macc <- mini_macc[sample(nrow(mini_macc), nrow(mini_mmag)),]
        mini_mgyr <- mini_mgyr[sample(nrow(mini_mgyr), nrow(mini_mmag)),]
        mini_mmag <- mini_mmag[sample(nrow(mini_mmag), nrow(mini_mmag)),]
      }
      mini_macc <- mini_macc %>% arrange(ts, mAcc_timestamp)
      mini_mgyr <- mini_mgyr %>% arrange(ts, mGyr_timestamp)
      mini_mmag <- mini_mmag %>% arrange(ts, mMag_timestamp)
      
      # user %>% group_by(uesr_info, ts) %>% summarise(n = n()) %>% arrange(desc(ts, p)) -> delete
      new_df_mAcc <- rbind(new_df_mAcc, mini_macc)
      new_df_mGyr <- rbind(new_df_mGyr, mini_mgyr)
      new_df_mMag <- rbind(new_df_mMag, mini_mmag)
    }
    print("타임스탬프 완료")
    variable_data <- cbind(new_df_mAcc[,1:6], new_df_mGyr[,2:4], new_df_mMag[,2:4])
    df <- left_join(df, variable_data, by = "ts")
    df %>% filter(is.na(ts) == FALSE) -> df
    user <- rbind(user, df)
  }
  
  user$user_info <- k
  user$timestamp <- user$mAcc_timestamp
  user <- user %>% select(-mAcc_timestamp)
  user %>% group_by(user_info, ts) %>% summarise(n = n()) %>% arrange(ts, n) %>%  filter(n < 50) -> delete
  delete_ts <- delete$ts
  user %>% filter(!ts %in% delete_ts) -> user
  write.csv(user, file = paste0("C:/R_base_files/user_", k, ".csv"))
}
