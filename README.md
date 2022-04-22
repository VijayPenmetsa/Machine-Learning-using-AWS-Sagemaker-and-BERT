# Recommendations for Covid Emergencies 

## Introduction

This project is a part of the college's Capstone work.

During the second wave of Corona Virus Pandemic India has witnessed a shortage of hospital beds due to high population. We decided to help the people in need of beds by providing them with information regarding available beds in their area. During this period, people started tweeting about help by asking for beds in their area. 
Originally we intended to deploy a model to do the inference in cloud and then comment on the tweets of people using Tweepy library, but due to the restrictions of tweepy for students, we couldn't retrieve the tweets that are older than a week. So we decided to build an application where we can enter the tweets and access a NLP model from the cloud and provide recommendations of available beds in their area.

In order to do this we're using Google's NLP(natural language processing) model BERT for understanding the type of bed needed (such as ICU, Oxygen, Ventilator) from the provided Tweet data, and recommend available bed type near the patients area using available beds dataset that we've acquired online.

For the demonstration of model deployment on AWS Sagemaker, and it's usage inside mobile and web apps, we've decided to build applications for Web, iOS, and Android platforms using Google's flutter framework. And for the data transfer between the Model Endpoints in AWS and the flutter applications we're relying on google's firebase (firestore).

<img width="997" alt="sample2" src="https://user-images.githubusercontent.com/50517893/163275611-307a8ed3-0273-42ae-8beb-3784dba0a542.png">

## Project Architecture

<img width="956" alt="architecture" src="https://user-images.githubusercontent.com/50517893/163254562-47c0d55c-f7d8-4650-bac3-d45600499ad1.png">

## Files

The project contains 3 main files. 
1. **bert_testing.ipynb** A Jupyter notebook for doing initial testing of BERT on the tweets data.
2. **sagemaker_notebook.ipynb** The sagemaker notebook instance is responsible for Model Inference, and Data transfer between the apps.
3. **BEDS dataframe acquisition and EDA.ipynb** Thisw file contains the Data Acquisition code and EDA on the BEDS dataset.
4. **recent_beds_df** This is a snapshot of the Beds Dataset.
5. **main.dart** The dart file contains main code for the User Interface, and Firebase (firestore) for data transfer.


The following are details of the files.

## bert_testing.ipynb 

The **main libraries** used in this notebook are _regex, pandas, numpy, matplotlib, and transformers._

### **Datasets**
1. **Available hospital beds data in India:**
- _It consists of available beds information of most major areas in India._
- _The details of beds include things like bed type, area, hospital name, hospital address, number of beds available, etc.._
- _Beds information's data source gets updated every 15 minutes, but for testing purposes, a specific snapshot of the data is being used._  
2. **Evaluation Dataset from twitter:**
- _For searching the tweets we've used search keywords like_ **#Covid19Indiahelp, need bed, urgent, critical, etc..** _but at the time of data collection using **tweepy** we've encountered a difficulty because the student developer account of tweepy only allowed us to collect tweets that are 7 days old. So for evaluation purposes, we've manually collected over 160 tweets from the twitter._
- _Example tweets:_

![4](https://user-images.githubusercontent.com/50517893/163264534-7d83d5a5-fa0c-447f-9b74-2fd03c86eb1f.PNG)

![Screenshot 2022-02-26 161118](https://user-images.githubusercontent.com/50517893/163264537-1faec36e-9bec-4be7-b7eb-cfd6209e8ae5.png)

### Most used hashtags

<img width="549" alt="hashtags" src="https://user-images.githubusercontent.com/50517893/163265973-ffe9eb81-6c73-47ee-ac6e-bd0c0cdbb720.png">

### Data Preperation

1. In the available beds dataframe, string values of all the area names are lowered for easier search.
2. The tweets evaluation dataset has been split into 4 parts for testing.
3. For recommending beds to the patient, we need 2 input parameters (bedtype and area), so we're removing tweets without area names.

### **_Model Inference_**

### Example Scenario

<img width="1093" alt="Screen Shot 2022-04-13 at 5 21 26 PM" src="https://user-images.githubusercontent.com/50517893/163272590-d730b7f8-1d1b-4e5c-b660-29b00698dee2.png">

The Question-Answering model of BERT requires 2 parameters, the **question and context**. 

In the above scenario, tweet data from the user is being used as context, and the question will be _what kind of bed is needed?_ 

Once the inference is done, we use the "**_bedtype_**" that we got from bert and the **_areaname_** inside the tweet, to search for the bed, and provide the user with recommendations of available bed using the front-end application.

If a bed type is provided in the tweet, the algorithm will try to retrieve beds belonging to that specific type. If a bedtype is not provided, we automatically provide recommendations of oxygen beds near the patients.

An example reply would be:
### 10 Oxygen beds are available in: AASTHA HOSPITAL, Badli Rd, Sector 19, Rohini, New Delhi, Delhi 110042, India

### **_Model Accuracy_**
There is no direct function available to test BERT's accuracy, so we designed a function _calculate_accuracy()_ that will analyze bert's inference result, and outputs the accuracy. The function looks for keywords like 'icu', 'oxygen', 'urgent', etc.. and if these words are found in the inference result, we consider it as a correct prediction.

BERT's accuracy performance for 4 evaluation datasets, without and with city names are as follows:

(area name is required for searching beds so as mentioned earlier we removed a few tweets in which we couldn't find any city names).

<img width="645" alt="accuracies" src="https://user-images.githubusercontent.com/50517893/163278502-547fa004-5a12-44ea-95d5-2003099a1b0f.png">

Accuracy table

|        ACCURACIES        |Including tweets without area names    | After removing tweets without area names                         |
|----------------|-------------------------------|-----------------------------|
|Evaluation Set 1   |90.47 %            | 100.00 %           |
|Evaluation Set 2   |83.33 %           |  95.83 %          |
|Evaluation Set 3   |88.09 %  | 84.21 % |
|Evaluation Set 4   |90.24 % | 95.23 % |

- As we can see, in 3/4 cases tweets with city names got more accuracy. This could've happened because the users mentioning city names are generally more specific about their requirements.

## sagemaker_instance.ipynb

The notebook is an AWS Sagemaker notebook instance for accessing **_BERT's Model endpoint_** deployed in Sagemaker.

(for more information on how to deploy a model in AWS Sagemaker, sign into sagemaker console and follow the instructions provided for jump-starting model deployment.)

- In this notebook we will be dealing directly with the user input from the application.
- The data transfer between this notebook and the flutter apps is done through the **firestore API**.
- To access the _deployed_model_ we use **boto3 API** (AWS SDK for python).
- Once the inference is done we use the areaname, and bedtype to search and recommend the available beds near the patient. The recommendation reply is again sent back to the flutter applications via firestore.
- In order to access the firestore from sagemaker we also need _firebase_credentials.json_ file, which can be obtained from the firebase console.

## Beds dataframe acquisition and EDA.ipynb

The data source updates every 15 minutes, so we saved a snapshot of the dataset and then performed EDA.

**Exploratory Data Analysis:**

**_missing values_**

<img width="1359" alt="missing" src="https://user-images.githubusercontent.com/42052561/164797746-f1f7f31a-1a57-46b9-9b43-2d89e37027e4.png">

**_most popular areas in the dataset based on the available hospitals_**

<img width="711" alt="Screen Shot 2022-04-22 at 4 03 08 PM" src="https://user-images.githubusercontent.com/42052561/164798201-d74ee135-a33e-4a78-9c71-fa17a82114d8.png">

**_Beds count for the entire dataframe_**

<img width="751" alt="total" src="https://user-images.githubusercontent.com/42052561/164798438-0a02cacc-b3d0-4bc2-9c1c-38b648393880.png">

**_Bed counts for the most popular areas_**

<img width="350" alt="bengaluru" src="https://user-images.githubusercontent.com/42052561/164798585-f9a6186d-9e23-44ec-88b3-7907bd38c0d9.png">  <img width="350" alt="c" src="https://user-images.githubusercontent.com/42052561/164802687-77c44ae9-b7f5-4a12-bee0-4657a689fd75.png">

<img width="350" alt="delhi" src="https://user-images.githubusercontent.com/42052561/164798620-353e47b9-9cee-47ce-a541-de45bd521579.png">  <img width="350" alt="w" src="https://user-images.githubusercontent.com/42052561/164802730-8e100d22-a008-4626-84fd-8ab96201bb43.png">

<img width="350" alt="pune" src="https://user-images.githubusercontent.com/42052561/164798643-038c1f76-a506-4224-b221-fde181da4250.png">  <img width="350" alt="m" src="https://user-images.githubusercontent.com/42052561/164802851-d3dfdde1-bea1-4a2b-ade0-a1d4a08b935b.png">

## main.dart

This app contains the main code for flutter apps which includes **(User Interface and Firestore API)**.

**NOTE**
- Before trying out this in your own app, make sure to install all the necessary dependencies.
- Minimum SDK version for the android application is 25.
- Minimum platform version for iOS is 15.0.
- Firebase credentials are needed for android, iOS, and web applications. Credentials can be obtained from the firebase console.

**User Interface:**
We have used a minimal user interface in order to get the functionality of the app up and running on time.

![ezgif com-gif-maker](https://user-images.githubusercontent.com/50517893/163285414-c66c1c24-c64f-491f-bbc5-76e0801819d6.gif)

# Conclusion
The project is a demonstration of leveraging the power of cloud for Machine Learning. We were able to do this project with the help of robust technologies from AWS(Amazon Web Services), GCP(Google Cloud Platform), Google's Flutter framework, and Google's NLP model BERT.

## Our Team:

**_Vijay Penmetsa, Ghanshyam Sutar, Sai Akshay Muralidhar, Yamini Soodireddy_**

_Under the guidance of:_
**_Vahid Hadavi_**





