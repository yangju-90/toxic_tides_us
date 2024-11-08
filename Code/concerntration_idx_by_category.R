library(rineq)
# set to the correct working directory
setwd('D:\\Box Sync\\Toxic Tides\\ToxicTides_US\\Code_Data_upload')


urban = 2 # 1 urban, 0 non-urban, 2 all
pw = 0 # 0 unweighted by population, 1 weighted by population

# Define the output directory path
dir_path <- "Results/concerntration_index/"
# Check if the directory exists, create one if not
if (!file.exists(dir_path)) {
  # Create the directory if it does not exist
  dir.create(dir_path, recursive = TRUE)
  cat("Directory created:", dir_path, "\n")
} else {
  cat("Directory already exists:", dir_path, "\n")
}

# calculate the concentration index for each facility category and selected
# socioeconomic variables
for (cid in cbind(1,2,3,4,5,6,7,8,9,10,11,18)){
  df = read.csv(sprintf("Data/analysis_sum_EAE_1000m_buffer_US_%s_25.csv",cid))
  df$exposed_205 = 0
  df$exposed_205[df$RCP85_Annual_2050>0]=1
  df$exposed_210 = 0
  df$exposed_210[df$RCP85_Annual_2100>0]=1
  df['est_pct_poverty']=100-df['est_pct_poverty']
  df['est_pct_nocar']= 100-df['est_pct_nocar']
  df['est_pct_renters']=100-df['est_pct_renters']
  df['est_pct_poc']=100-df['est_pct_poc']
  df['est_pct_langisolation']=100-df['est_pct_langisolation']
  df['est_pct_latinx']=100-df['est_pct_latinx']
  df['est_pct_nhblack']=100-df['est_pct_nhblack']
  df['est_pct_asianpi']=100-df['est_pct_asianpi']
  df['est_pct_native']=100-df['est_pct_native']
  df['est_pct_otherpoc']=100-df['est_pct_otherpoc']
  df['pct_novote'] = 100-df['pct_novote']
  
  # if unweighted, assign population=1
  if (pw==0){
   df$tot_pop=1 
  }
  
  #########################concentration index for EAE#########################
  res = data.frame()
  idx=1
  for (exp in cbind('RCP85_Annual_2050','RCP85_Annual_2100')){
    for (var in cbind('est_pct_poverty','est_pct_renters','est_pct_poc','est_pct_langisolation','pct_novote','est_pct_latinx','est_pct_nhblack','est_pct_asianpi',
                      'est_pct_native','est_pct_otherpoc','est_pct_nocar')){
      if (urban > 1){
        sub_df = df[(df$low_lying==1),]
      } else {
        sub_df = df[(df$low_lying==1)&(df$urban==urban),]
      }
      ci = with(sub_df, ci(y =get(exp), x = get(var), type = "CI",wt = tot_pop))
      res[idx,'exposure'] = exp
      res[idx,'epa_region']='US'
      res[idx,'variable'] = var
      res[idx,'CI'] = ci$concentration_index
      res[idx,'se']=sqrt(ci$variance)
      res[idx,'nobs']=nrow(sub_df)
      idx=idx+1
      out = cbind(ci$fractional_rank,ci$outcome)
      # store the detailed values from concentration index calculation for plotting concerntration curves
      write.csv(out,sprintf("Results/concerntration_index/ci_details_eae_%s_%s_category%s_pw%s_urban%s.csv",exp,var,cid,pw,urban)) # entire US
    }
  }
  res$lower = res$CI-1.96*res$se
  res$upper = res$CI+1.96*res$se
  # store the concentration index values
  write.csv(res, sprintf("Results/concerntration_index/ci_eae_category%s_pw%s_urban%s.csv",cid,pw,urban), row.names=FALSE)
  
  ########################concentration index for number of exposed facilities#########################
  df = read.csv(sprintf("Data/analysis_count_1000m_buffer_US_%s_25.csv",cid))
  df$exposed_205 = 0
  df$exposed_205[df$RCP85_Annual_2050>0]=1
  df$exposed_210 = 0
  df$exposed_210[df$RCP85_Annual_2100>0]=1
  df['est_pct_poverty']=100-df['est_pct_poverty']
  df['est_pct_renters']=100-df['est_pct_renters']
  df['est_pct_poc']=100-df['est_pct_poc']
  df['est_pct_nocar']= 100-df['est_pct_nocar']
  df['est_pct_langisolation']=100-df['est_pct_langisolation']
  df['est_pct_latinx']=100-df['est_pct_latinx']
  df['est_pct_nhblack']=100-df['est_pct_nhblack']
  df['est_pct_asianpi']=100-df['est_pct_asianpi']
  df['est_pct_native']=100-df['est_pct_native']
  df['est_pct_otherpoc']=100-df['est_pct_otherpoc']
  df['pct_novote'] = 100-df['pct_novote']
  # if unweighted, assign population=1
  if (pw==0){
    df$tot_pop=1 
  }

  res = data.frame()
  # colnames(res)=c('epa_region')
  idx=1
  for (exp in cbind('RCP85_Annual_2050','RCP85_Annual_2100')){
    for (var in cbind('est_pct_poverty','est_pct_renters','est_pct_poc','est_pct_langisolation','pct_novote','est_pct_latinx','est_pct_nhblack','est_pct_asianpi',
                      'est_pct_native','est_pct_otherpoc','est_pct_nocar')){
      if (urban > 1){
        sub_df = df[(df$low_lying==1),]
      } else {
        sub_df = df[(df$low_lying==1)&(df$urban==urban),]
      }
      ci = with(sub_df, ci(y =get(exp), x = get(var),wt = tot_pop, type = "CI")) #,wt = tot_pop
      res[idx,'exposure'] = exp
      res[idx,'epa_region']='US'
      res[idx,'variable'] = var
      res[idx,'CI'] = ci$concentration_index
      res[idx,'se']=sqrt(ci$variance)
      res[idx,'nobs']=nrow(sub_df)
      idx=idx+1
      out = cbind(ci$fractional_rank,ci$outcome)
      # store the detailed values from concentration index calculation for plotting concerntration curves
      write.csv(out,sprintf("Results/concerntration_index/ci_details_count_%s_%s_category%s_pw%s_urban%s.csv",exp,var,cid,pw,urban)) #entire US
    }
  }
  res$lower = res$CI-1.96*res$se
  res$upper = res$CI+1.96*res$se
  # store the concentration index values
  write.csv(res, sprintf("Results/concerntration_index/ci_count_category%s_pw%s_urban%s.csv",cid,pw,urban), row.names=FALSE)
}
###end
  