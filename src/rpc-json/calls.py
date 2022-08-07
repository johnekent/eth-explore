import requests

from itertools import count

_endpoint = 'http://localhost:8545'
_request_id = count()
 
def send_request(session, endpoint, method, params):
    
    response = session.post(
        endpoint,
        json={"jsonrpc": "2.0", "method": method, "params": params, "id": next(_request_id)},
        headers={'Content-type': 'application/json'})

    return response

def _get_no_param_response(method):
    """_summary_

    Args:
        method (_type_): _description_

    Returns:
        _type_: _description_

    Raises:
        RuntimeError if not 200
    """

    response = send_request(
        session=session,
        endpoint=_endpoint,
        method=method,
        params=[])

    if not response.status_code == 200:
        raise RuntimeError(f"The request for method {method} returned a non-200 response of {response}")

    return response

def get_accounts(session):

    response = _get_no_param_response("eth_accounts")

    accounts = response.json()['result']
    return f"The accounts in the network are {accounts}"


def get_peers(session):
    response = _get_no_param_response("admin_peers")

    peers = response.json()['result']

    return f"The peers in the network are {peers}"


if __name__ == "__main__":

    print(f"The RPC Endpoint is : {_endpoint}")
    
    session = requests.session()

    print(get_accounts(session))
    print(get_peers(session))

