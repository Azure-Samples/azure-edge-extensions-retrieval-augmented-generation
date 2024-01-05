import streamlit as st
import time
import logging
import requests

#logging.basicConfig(level=logging.INFO)

# Check response for up to 100/5=20 times (300s, 5min)
CHECK_NUM = 100 
CHECK_INTERVAL_SEC = 5 

retrieval_prompt = '''Use the Content to answer the Search Query.

Search Query: 

SEARCH_QUERY_HERE

Search Content and Answer: 

'''

def check_processed_result(request_id):
    check_url = f'http://rag-interface-service:8701/check_processed_result/{request_id}'
    response = requests.get(check_url)
    
    if response.status_code == 200:
        result_data = response.json()
        if result_data['status'] == 'success':
            st.success(f"{result_data['processed_result']}")
            return True
    
    return False

def publish_user_input(user_input_json):
    backend_url = 'http://rag-interface-service:8701/webpublish'
    try:
        response = requests.post(backend_url, json=user_input_json)
        if response.status_code == 200:
            st.success(response.json()['message'])
            request_id = response.json()['request_id']
            # Check for processed results periodically
            for _ in range(CHECK_NUM):  
                if check_processed_result(request_id):
                    break
                time.sleep(CHECK_INTERVAL_SEC)
        else:
            st.error('Failed to publish user input to the backend')
    except requests.RequestException as e:
        st.error(f'Request failed: {e}')

def query_retrieval():
    st.title('Please input your question and press enter to search:')
    with st.spinner(text="Loading..."):
        # get the index names from the backend VDB module
        index_names = requests.get('http://rag-vdb-service:8602/list_index_names').json()['index_names']
        index_name = st.selectbox('Please select an index name.',index_names)
        st.write('You selected:', index_name)

    prompt = st.text_input('please input your question')
    # If the user hits enter
    if prompt:
        with st.spinner(text="Document Searching..."):
            retrieval_prepped = retrieval_prompt.replace('SEARCH_QUERY_HERE',prompt)
            st.write(f"{retrieval_prepped}\n\n")

            user_input_json = {'user_query': prompt, 'index_name': index_name}
            publish_user_input(user_input_json)


if __name__ == "__main__":
    query_retrieval()

