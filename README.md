# Recommendations for Covid Emergencies 

This project is a part of the college's Capstone work.

During the second wave of Corona Virus Pandemic India has witnessed a shortage of hospital beds due to high population. We decided to help the people in need of beds by providing them with information regarding available beds in their area. During this period, people started tweeting about help by asking for beds in their area. 
Originally we intended to deploy a model to do the inference in cloud and then comment on the tweets of people using Tweepy library, but due to the restrictions of tweepy for students, we couldn't retrieve the tweets that are older than a week. So we decided to build an application where we can enter the tweets and access a NLP model from the cloud and recommend them with available beds in their area.

In order to do this we're using Google's NLP model BERT for understanding the type of bed needed (such as ICU, Oxygen, Ventilator) from the provided Tweet data, and recommend available bed type near the patients area using available beds dataset that we've acquired online.

For the demonstration of model deployment on AWS Sagemaker, and it's usage inside mobile and web apps, we've decided to build applications for Web, iOS, and Android platforms using Google's flutter framework. And for the data transfer between the Model Endpoints in AWS and the flutter applications we're relying on google's firebase.


# Files

The project contains 3 main files. 
1. **bert_testing.ipynb** A Jupyter notebook for doing initial testing of BERT on the tweets data.
2. **sagemaker_notebook.ipynb** The sagemaker notebook instance is responsible for Model Inference, and Data transfer between the apps.
3. **main.dart** The dart file contains main code for the User Interface, and Firebase for data transfer.

## Project Architecture

<img width="956" alt="architecture" src="https://user-images.githubusercontent.com/50517893/163254562-47c0d55c-f7d8-4650-bac3-d45600499ad1.png">

