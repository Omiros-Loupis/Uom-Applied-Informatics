# %%
#Imports
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import StratifiedKFold
from sklearn.preprocessing import MinMaxScaler
from sklearn.metrics import confusion_matrix, accuracy_score, precision_score, recall_score, f1_score, roc_auc_score, ConfusionMatrixDisplay

#Automatic plot saving 
import os 

#Define the output directory name

output_folder = "Matrices"

#Create the directory

if not os.path.exists(output_folder):
    os.makedirs(output_folder)
    print(f"Created folder: {output_folder}")

#Loading data
#If you work from colab
#from google.colab import drive
#drive.mount('/content/drive')
#file_path = '/content/drive/MyDrive/Dataset2Use_Assignment1.xlsx'
#df = pd.read_excel(file_path)

#If you work from somewhere else
file_path = 'Dataset2Use_Assignment1.xlsx'
df = pd.read_excel(file_path)
#Renaming for simplicity
df.columns = [
    'Inventory_Turnover', 'ROA', 'Expenses_Sales', 'Quick_Ratio', 'Days_Receivable', 'Total_Debt_Assets', 'Inventory_Duration', 'Log_Employees',
    'Exports', 'imports', 'Agencies', 'Status', 'Year'
]


# %%
#Figure 1
plt.figure(figsize=(10, 6))
ax = sns.countplot(x='Year', data=df, hue='Status')
plt.title('Figure 1: Number of healthy (1) and bankrupt (2) companies per year')
plt.xlabel('Year')
plt.ylabel('Number of companies')
plt.legend(title='Company Status', labels=['Healthy (1)', 'Bankrupt (2)'])
filename = f"Figure 1.png"
save_path = os.path.join(output_folder, filename)
plt.savefig(save_path)
print(f"Saved plot: {save_path}")
plt.show()


#Figure 2
indicators_df = df.iloc[:,0:8]
indicators_names = indicators_df.columns

#Spliting the data into healty and bankrupt
healthy_data = df[df['Status'] ==1].iloc[:, 0:8]
bankrupt_data = df[df['Status'] ==2].iloc[:, 0:8]

#Calculating stats
healthy_stats = healthy_data.agg(['min', 'max', 'mean']).T
bankrupt_stats = bankrupt_data.agg(['min', 'max', 'mean']).T

#Creating 2 subfigures
fig,(ax1, ax2) = plt.subplots(2, 1, figsize=(16,20))

#Plotting for healthy companies
healthy_stats.plot(kind='bar', ax=ax1, width=0.8)
ax1.set_title('Figure 2a: Min, Max, Average for healthy companies (Status 1)')
ax1.set_ylabel('Values')
ax1.set_xticklabels(indicators_names, rotation=30, ha='right')
for container in ax1.containers:
    ax1.bar_label(container, fmt='%.2f', padding=5, fontsize=9, rotation=90)

#Adding more space at the top of the plot
ax1.set_ylim(top=ax1.get_ylim()[1]*1.25)

#Plotting for bankrupt companies
bankrupt_stats.plot(kind='bar', ax=ax2, width=0.8)
ax2.set_title('Figure 2b: Min, Max, Average for bankrupt companies (Status 2)')
ax2.set_xticklabels(indicators_names, rotation =30, ha="right")

for container in ax2.containers:
    ax2.bar_label(container, fmt='%.2f', padding=5, fontsize=9, rotation=90)

#Adding more space at the top of the plot
ax2.set_ylim(top=ax2.get_ylim()[1]*1.25)

plt.tight_layout()
filename = f"Figure 2.png"
save_path = os.path.join(output_folder, filename)
plt.savefig(save_path)
print(f"Saved plot: {save_path}")
plt.show()

#Checking for NaNs

if df.isnull().values.any():
  print("Warning! There are NaNs in the dataset")
else:
  print("No NaNs in the dataset")


# %%
#Normalisation
from sklearn.preprocessing import MinMaxScaler

features_to_scale = df.columns[0:11]

scaler = MinMaxScaler(feature_range=(0, 1))
df[features_to_scale] = scaler.fit_transform(df[features_to_scale])

print("Normalisation is finished")



# %%
#Initialization
results_list = []

#Preparing for Stratified kfold
X = df.drop(columns=['Status', 'Year']).values
y = df['Status'].values

skf = StratifiedKFold(n_splits=4, shuffle=True, random_state=42)

for fold_idx, (train_index, test_index) in enumerate(skf.split(X, y)):
  print(f"\n" + "="*30)
  print(f" PROCESSING FOLD {fold_idx+1} ")
  print(f"="*30)

  #Splitting the data
  X_train, X_test = X[train_index], X[test_index]
  y_train, y_test = y[train_index], y[test_index]

  #Counting (1 = Healthy, 2 = Bankrupt)
  train_h = (y_train == 1).sum()
  train_b = (y_train == 2).sum()
  test_h = (y_test == 1).sum()
  test_b = (y_test == 2).sum()

  #Printing results
  print(f"Train set: Healthy = {train_h}, Bankrupt = {train_b}")
  print(f"Test set: Healthy = {test_h}, Bankrupt = {test_b}")

  #Check if healthy companies are more than 3 times the bankrupt ones
  if train_h > 3*train_b:
    #Find indices for each class within the current training set
    indices_h = np.where(y_train == 1)[0]
    indices_b = np.where(y_train == 2)[0]

    #Randomly select healthy companies to achieve a 3:1 ratio
    np.random.seed(42)
    required_h_count = 3 * train_b
    selected_h_indices = np.random.choice(indices_h, size=required_h_count, replace=False)

    #Combine the selected healthy indices with all bankrupt indices
    balanced_indices = np.concatenate([selected_h_indices, indices_b])

    #Shuffle indices to mix the classes
    np.random.shuffle(balanced_indices)

    #Update the training set with balanced data
    X_train = X_train[balanced_indices]
    y_train = y_train[balanced_indices]

    #Note! Companies removed from the train set are not moved to the test set

    #Print the new distributions
    print("\nDistributions after balancing:")
    print(f"Train set (Balanced): Healthy (1) = {(y_train==1).sum()}, Bankrupt (2) = {(y_train==2).sum()}")
    print(f"Test set (Unchanged): Healthy (1) = {(y_test==1).sum()}, Bankrupt (2) = {(y_test == 2).sum()}")

  #Linear Discriminant Analysis
  from sklearn.discriminant_analysis import LinearDiscriminantAnalysis

  #Initialize and train the model
  lda = LinearDiscriminantAnalysis()
  lda.fit(X_train, y_train)

  #Evaluation for LDA
  for set_name, X_eval, y_eval in [("Train", X_train, y_train), ("Test", X_test, y_test)]:

    #Predictions
    y_pred = lda.predict(X_eval)
    #Probability for ROC-AUC
    y_proba = lda.predict_proba(X_eval)[:, 1]

    #Calculating metrics
    acc = accuracy_score(y_eval, y_pred)
    prec = precision_score(y_eval, y_pred, pos_label=2, zero_division=0)
    rec = recall_score(y_eval, y_pred, pos_label=2, zero_division=0)
    f1 = f1_score(y_eval, y_pred, pos_label=2, zero_division=0)

    #Binary map for ROC-AUC
    y_eval_binary = np.where(y_eval == 2, 1, 0)
    auc = roc_auc_score(y_eval_binary, y_proba)

    #Printing metrics
    print(f"[{set_name}] LDA -> Accuracy: {acc:.2f}, Precision: {prec:.2f}, Recall: {rec:.2f}, F1: {f1:.2f}, AUC: {auc:.2f}")

    #Confusion matrix
    cm = confusion_matrix(y_eval, y_pred)
    tn, fp, fn, tp = cm.ravel()

    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=['Healthy', 'Bankrupt'])
    disp.plot(cmap=plt.cm.Blues)
    plt.title(f"LDA - {set_name} Set (Fold {fold_idx + 1})")
    
    #Saving .png
    filename = f"LDA_{set_name}_Set_Fold_{fold_idx + 1}.png"
    save_path = os.path.join(output_folder, filename)
    plt.savefig(save_path)
    print(f"Saved: {save_path}")
    plt.show()

    #Storing the data
    results_list.append({
        "Classifier Name": "Linear Discriminant Analysis",
        "Training or test set": set_name,
        "Balanced or unbalanced": "Balanced",
        "Number of training samples": len(y_train),
        "Number of non healthy companies in training sample": (y_train == 2).sum(),
        "True Positves": int(tp),
        "True Negatives": int(tn),
        "False Positives": int(fp),
        "False Negatives": int(fn),
        "ROC-AUC": round(auc, 2)
    })

  #Logistic Regression
  from sklearn.linear_model import LogisticRegression

  #Initialize and train the model
  log_reg = LogisticRegression(max_iter = 1000, random_state=42)
  log_reg.fit(X_train, y_train)

  #Evaluation for Logistic Regression
  for set_name, X_eval, y_eval in [("Train", X_train, y_train), ("Test", X_test, y_test)]:

    # Predictions and Probabilities
    y_pred = log_reg.predict(X_eval)
    y_proba = log_reg.predict_proba(X_eval)[:, 1]

    #Calculating metrics
    acc = accuracy_score(y_eval, y_pred)
    prec = precision_score(y_eval, y_pred, pos_label=2, zero_division=0)
    rec = recall_score(y_eval, y_pred, pos_label=2, zero_division=0)
    f1 = f1_score(y_eval, y_pred, pos_label=2, zero_division=0)

    #Binary map for ROC-AUC
    y_eval_binary = np.where(y_eval == 2, 1, 0)
    auc = roc_auc_score(y_eval_binary, y_proba)

    #Printing metrics
    print(f"[{set_name}] Logistic Regression -> Accuracy: {acc:.2f}, Precision: {prec:.2f}, Recall: {rec:.2f}, F1: {f1:.2f}, AUC: {auc:.2f}")

    #Confusion Matrix
    cm = confusion_matrix(y_eval, y_pred)
    tn, fp, fn, tp = cm.ravel()

    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=['Healthy', 'Bankrupt'])
    disp.plot(cmap=plt.cm.Reds) #Using Reds to distinguish from LDA
    plt.title(f"Logistic Regression - {set_name} Set (Fold {fold_idx + 1})")
    #Saving .png
    filename = f"LR_{set_name}_Set_Fold_{fold_idx + 1}.png"
    save_path = os.path.join(output_folder, filename)
    plt.savefig(save_path)
    print(f"Saved: {save_path}")
    plt.show()

    #Storing the data
    results_list.append({
        "Classifier Name": "Logistic Regression",
        "Training or test set": set_name,
        "Balanced or unbalanced": "Balanced",
        "Number of training samples": len(y_train),
        "Number of non healthy companies in training sample": (y_train == 2).sum(),
        "True Positves": int(tp),
        "True Negatives": int(tn),
        "False Positives": int(fp),
        "False Negatives": int(fn),
        "ROC-AUC": round(auc, 2)
    })

  # Decision Tree Classifier
  from sklearn.tree import DecisionTreeClassifier

  # Initialize and train the model
  dtree = DecisionTreeClassifier(random_state=42)
  dtree.fit(X_train, y_train)

  # Evaluation for Decision Tree
  for set_name, X_eval, y_eval in [("Train", X_train, y_train), ("Test", X_test, y_test)]:

      # Predictions and Probabilities
      y_pred = dtree.predict(X_eval)
      y_proba = dtree.predict_proba(X_eval)[:, 1] # Probability of the positive class (Bankrupt)

      # Calculating metrics
      acc = accuracy_score(y_eval, y_pred)
      prec = precision_score(y_eval, y_pred, pos_label=2, zero_division=0)
      rec = recall_score(y_eval, y_pred, pos_label=2, zero_division=0)
      f1 = f1_score(y_eval, y_pred, pos_label=2, zero_division=0)

      # Binary map for ROC-AUC
      y_eval_binary = np.where(y_eval == 2, 1, 0)
      auc = roc_auc_score(y_eval_binary, y_proba)

      # Printing metrics
      print(f"[{set_name}] Decision Tree -> Accuracy: {acc:.2f}, Precision: {prec:.2f}, Recall: {rec:.2f}, F1: {f1:.2f}, AUC: {auc:.2f}")

      # Confusion Matrix
      cm = confusion_matrix(y_eval, y_pred)
      tn, fp, fn, tp = cm.ravel()

      disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=['Healthy', 'Bankrupt'])
      disp.plot(cmap=plt.cm.Greens) # Using Greens to distinguish from other models
      plt.title(f"Decision Tree - {set_name} Set (Fold {fold_idx + 1})")
      #Saving .png
      filename = f"DTC_{set_name}_Set_Fold_{fold_idx + 1}.png"
      save_path = os.path.join(output_folder, filename)
      plt.savefig(save_path)
      print(f"Saved: {save_path}")
      plt.show()

      # Storing the data
      results_list.append({
          "Classifier Name": "Decision Tree Classifier",
          "Training or test set": set_name,
          "Balanced or unbalanced": "Balanced",
          "Number of training samples": len(y_train),
          "Number of non healthy companies in training sample": (y_train == 2).sum(),
          "True Positves": int(tp),
          "True Negatives": int(tn),
          "False Positives": int(fp),
          "False Negatives": int(fn),
          "ROC-AUC": round(auc, 2)
      })

  #Random Forests
  from sklearn.ensemble import RandomForestClassifier

  #Initialize model with 100 trees
  rf_clf = RandomForestClassifier(n_estimators = 100, random_state = 42)

  #Fit the model using the balanced training data
  rf_clf.fit(X_train, y_train)

  #Evaluation for Random Forests
  for set_name, X_eval, y_eval in [("Train", X_train, y_train), ("Test", X_test, y_test)]:

    # Predictions and Probabilities
    y_pred = rf_clf.predict(X_eval)
    y_proba = rf_clf.predict_proba(X_eval)[:, 1]

    #Calculate metrics
    acc = accuracy_score(y_eval, y_pred)
    prec = precision_score(y_eval, y_pred, pos_label=2, zero_division=0)
    rec = recall_score(y_eval, y_pred, pos_label=2, zero_division=0)
    f1 = f1_score(y_eval, y_pred, pos_label=2, zero_division=0)

    # Binary map for ROC-AUC
    y_eval_binary = np.where(y_eval == 2, 1, 0)
    auc = roc_auc_score(y_eval_binary, y_proba)

    # Print results
    print(f"[{set_name}] Random Forest -> Accuracy: {acc:.2f}, Precision: {prec:.2f}, Recall: {rec:.2f}, F1: {f1:.2f}, AUC: {auc:.2f}")

    #Confusin Matrix
    cm = confusion_matrix(y_eval, y_pred)
    tn, fp, fn, tp = cm.ravel()

    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=['Healthy', 'Bankrupt'])
    disp.plot(cmap=plt.cm.Purples) # Using Purples for Random Forests
    plt.title(f"Random Forest - {set_name} Set (Fold {fold_idx + 1})")
    #Saving .png
    filename = f"RF_{set_name}_Set_Fold_{fold_idx + 1}.png"
    save_path = os.path.join(output_folder, filename)
    plt.savefig(save_path)
    print(f"Saved: {save_path}")
    plt.show()

    #Storing the data
    results_list.append({
          "Classifier Name": "Random Forests",
          "Training or test set": set_name,
          "Balanced or unbalanced": "Balanced",
          "Number of training samples": len(y_train),
          "Number of non healthy companies in training sample": (y_train == 2).sum(),
          "True Positves": int(tp),
          "True Negatives": int(tn),
          "False Positives": int(fp),
          "False Negatives": int(fn),
          "ROC-AUC": round(auc, 2)
    })

  #K-nearest neighbors
  from sklearn.neighbors import KNeighborsClassifier

  # Initialize
  knn_clf = KNeighborsClassifier(n_neighbors=5)

  #Fit the model to using the balanced training data
  knn_clf.fit(X_train, y_train)

  #Evaluation for knn
  for set_name, X_eval, y_eval in [("Train", X_train, y_train), ("Test", X_test, y_test)]:

    #Predictions and probabilities
    y_pred = knn_clf.predict(X_eval)
    y_proba = knn_clf.predict_proba(X_eval)[:, 1]

    #Calculating metrics
    acc = accuracy_score(y_eval, y_pred)
    prec = precision_score(y_eval, y_pred, pos_label=2, zero_division=0)
    rec = recall_score(y_eval, y_pred, pos_label=2, zero_division=0)
    f1 = f1_score(y_eval, y_pred, pos_label=2, zero_division=0)

    # Binary map for ROC-AUC
    y_eval_binary = np.where(y_eval == 2, 1, 0)
    auc = roc_auc_score(y_eval_binary, y_proba)

    # Printing metrics to screen
    print(f"[{set_name}] kNN -> Accuracy: {acc:.2f}, Precision: {prec:.2f}, Recall: {rec:.2f}, F1: {f1:.2f}, AUC: {auc:.2f}")

    #Confusion Matrix
    cm = confusion_matrix(y_eval, y_pred)
    tn, fp, fn, tp = cm.ravel()

    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=['Healthy', 'Bankrupt'])
    disp.plot(cmap=plt.cm.YlOrBr) # Using Yellow/Orange/Brown for kNN
    plt.title(f"kNN - {set_name} Set (Fold {fold_idx + 1})")
    #Saving .png
    filename = f"kNN_{set_name}_Set_Fold_{fold_idx + 1}.png"
    save_path = os.path.join(output_folder, filename)
    plt.savefig(save_path)
    print(f"Saved: {save_path}")
    plt.show()

    #Storing the data
    results_list.append({
          "Classifier Name": "k-Nearest Neighbors",
          "Training or test set": set_name,
          "Balanced or unbalanced": "Balanced",
          "Number of training samples": len(y_train),
          "Number of non healthy companies in training sample": (y_train == 2).sum(),
          "True Positves": int(tp),
          "True Negatives": int(tn),
          "False Positives": int(fp),
          "False Negatives": int(fn),
          "ROC-AUC": round(auc, 2)
  })

  #Naive Bayes
  from sklearn.naive_bayes import GaussianNB

  #Initialize Naive Bayes
  #This model assumes that features follow a normal distribution
  nb_clf = GaussianNB()

  #Fit the model with the balanced training data
  nb_clf.fit(X_train, y_train)

  #Evaluation for Naive Bayes
  for set_name, X_eval, y_eval in [("Train", X_train, y_train), ("Test", X_test, y_test)]:

    # Predictions and Probabilities
    y_pred = nb_clf.predict(X_eval)
    y_proba = nb_clf.predict_proba(X_eval)[:, 1]

    #Calculating metrics
    acc = accuracy_score(y_eval, y_pred)
    prec = precision_score(y_eval, y_pred, pos_label=2, zero_division=0)
    rec = recall_score(y_eval, y_pred, pos_label=2, zero_division=0)
    f1 = f1_score(y_eval, y_pred, pos_label=2, zero_division=0)

    # Binary map for ROC-AUC
    y_eval_binary = np.where(y_eval == 2, 1, 0)
    auc = roc_auc_score(y_eval_binary, y_proba)

    # Printing metrics to screen
    print(f"[{set_name}] Naïve Bayes -> Accuracy: {acc:.2f}, Precision: {prec:.2f}, Recall: {rec:.2f}, F1: {f1:.2f}, AUC: {auc:.2f}")

    #Confusion matrix
    cm = confusion_matrix(y_eval, y_pred)
    tn, fp, fn, tp = cm.ravel()

    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=['Healthy', 'Bankrupt'])
    disp.plot(cmap=plt.cm.Greys) # Using Greys for Naïve Bayes
    plt.title(f"Naïve Bayes - {set_name} Set (Fold {fold_idx + 1})")
    #Saving .png
    filename = f"NB_{set_name}_Set_Fold_{fold_idx + 1}.png"
    save_path = os.path.join(output_folder, filename)
    plt.savefig(save_path)
    print(f"Saved: {save_path}")
    plt.show()

    #Storing the data
    results_list.append({
            "Classifier Name": "Naïve Bayes",
            "Training or test set": set_name,
            "Balanced or unbalanced": "Balanced",
            "Number of training samples": len(y_train),
            "Number of non healthy companies in training sample": (y_train == 2).sum(),
            "True Positves": int(tp),
            "True Negatives": int(tn),
            "False Positives": int(fp),
            "False Negatives": int(fn),
            "ROC-AUC": round(auc, 2)
    })
  
  #Support Vector Machines (SVM)
  from sklearn.svm import SVC

  #Initialize SVM
  #We set probability=True to enable predict_proba for ROC-AUC calculation
  svm_clf = SVC(probability=True, random_state=42)

  #Fit the model to the balanced training data
  svm_clf.fit(X_train, y_train)

  #Evaluation for SVM
  for set_name, X_eval, y_eval in [("Train", X_train, y_train), ("Test", X_test, y_test)]:

    # Predictions and Probabilities
    y_pred = svm_clf.predict(X_eval)
    y_proba = svm_clf.predict_proba(X_eval)[:, 1]

    # Calculating metrics
    acc = accuracy_score(y_eval, y_pred)
    prec = precision_score(y_eval, y_pred, pos_label=2, zero_division=0)
    rec = recall_score(y_eval, y_pred, pos_label=2, zero_division=0)
    f1 = f1_score(y_eval, y_pred, pos_label=2, zero_division=0)

    # Binary map for ROC-AUC
    y_eval_binary = np.where(y_eval == 2, 1, 0)
    auc = roc_auc_score(y_eval_binary, y_proba)

    # Printing metrics to screen
    print(f"[{set_name}] SVM -> Accuracy: {acc:.2f}, Precision: {prec:.2f}, Recall: {rec:.2f}, F1: {f1:.2f}, AUC: {auc:.2f}")

    # Confusion matrix
    cm = confusion_matrix(y_eval, y_pred)
    tn, fp, fn, tp = cm.ravel()

    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=['Healthy', 'Bankrupt'])
    disp.plot(cmap=plt.cm.plasma) #Using plasma for SVM 
    plt.title(f"SVM - {set_name} Set (Fold {fold_idx + 1})")
    #Saving .png
    filename = f"SVM_{set_name}_Set_Fold_{fold_idx + 1}.png"
    save_path = os.path.join(output_folder, filename)
    plt.savefig(save_path)
    print(f"Saved: {save_path}")
    plt.show()

    #Storing the data
    results_list.append({
          "Classifier Name": "Support Vector Machines",
          "Training or test set": set_name,
          "Balanced or unbalanced": "Balanced",
          "Number of training samples": len(y_train),
          "Number of non healthy companies in training sample": (y_train == 2).sum(),
          "True Positves": int(tp),
          "True Negatives": int(tn),
          "False Positives": int(fp),
          "False Negatives": int(fn),
          "ROC-AUC": round(auc, 2)
    })
  #Gradient Boosting (Extra model)
  from sklearn.ensemble import GradientBoostingClassifier

  #Initialize the model
  gb_clf = GradientBoostingClassifier(random_state=42)

  #Fit the model using the balanced training data
  gb_clf.fit(X_train, y_train)

  #Evaluation for Gradient Boosting
  for set_name, X_eval, y_eval in [("Train", X_train, y_train), ("Test", X_test, y_test)]:

    # Predictions and Probabilities
    y_pred = gb_clf.predict(X_eval)
    y_proba = gb_clf.predict_proba(X_eval)[:, 1]

    # Calculating metrics
    acc = accuracy_score(y_eval, y_pred)
    prec = precision_score(y_eval, y_pred, pos_label=2, zero_division=0)
    rec = recall_score(y_eval, y_pred, pos_label=2, zero_division=0)
    f1 = f1_score(y_eval, y_pred, pos_label=2, zero_division=0)

    # Binary map for ROC-AUC
    y_eval_binary = np.where(y_eval == 2, 1, 0)
    auc = roc_auc_score(y_eval_binary, y_proba)

    # Printing metrics
    print(f"[{set_name}] Gradient Boosting -> Accuracy: {acc:.2f}, Precision: {prec:.2f}, Recall: {rec:.2f}, F1: {f1:.2f}, AUC: {auc:.2f}")

    # Confusion matrix figure
    cm = confusion_matrix(y_eval, y_pred)
    tn, fp, fn, tp = cm.ravel()

    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=['Healthy', 'Bankrupt'])
    disp.plot(cmap=plt.cm.Wistia) # Using Wistia (Orange-Yellow) for Gradient Boosting
    plt.title(f"Gradient Boosting - {set_name} Set (Fold {fold_idx + 1})")
    #Saving .png
    filename = f"GB_{set_name}_Set_Fold_{fold_idx + 1}.png"
    save_path = os.path.join(output_folder, filename)
    plt.savefig(save_path)
    print(f"Saved: {save_path}")
    plt.show()

    # Storing the data 
    results_list.append({
            "Classifier Name": "Gradient Boosting",
            "Training or test set": set_name,
            "Balanced or unbalanced": "Balanced",
            "Number of training samples": len(y_train),
            "Number of non healthy companies in training sample": (y_train == 2).sum(),
            "True Positves": int(tp),
            "True Negatives": int(tn),
            "False Positives": int(fp),
            "False Negatives": int(fn),
            "ROC-AUC": round(auc, 2)
  })



# %%
#Exporting results to .csv
results_df = pd.DataFrame(results_list)

#Using index=False to avoid saving the row numbers
results_df.to_csv("assignment_ML.csv", index=False)

print("Success! 'assignment_ML.csv' was created!")

results_df.head()



