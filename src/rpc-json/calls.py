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

def _get_no_param_response(session, method):
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

    response = _get_no_param_response(session=session, method="eth_accounts")

    accounts = response.json()['result']
    return accounts

def get_account_balance(session, account):

    #print(f"Getting balance for {account} which is of type {type(account)}")
    params = [account, 'latest']

    response = send_request(
        session=session,
        endpoint=_endpoint,
        method="eth_getBalance",
        params=params
    )

    if response.status_code == 200:
        hex_balance = response.json()['result']
        return int(hex_balance, base=16)

    # give the full deal if not
    return response.json()

def get_peers(session):
    response = _get_no_param_response("admin_peers")

    peers = response.json()['result']

    return f"The peers in the network are {peers}"

def unlock_account(session, account, passphrase_file, duration):

    passphrase = None
    with open(passphrase_file, "r") as f:
        passphrase = f.readline().split()[0]

    print(f"Passphrase is >>>{passphrase}<<<")

    response = send_request(
        session=session,
        endpoint=_endpoint,
        method="personal_unlockAccount",
        params=[account, passphrase, duration]
    )

    print(f"Unlock account had rc of {response.status_code} and json message of {response.json()}")


def create_contract(session, from_address, bytecode_file):
    """Create a contract from the given file's bytecode.
    This uses the unsigned sendTransaction.

    Args:
        session (_type_): _description_
        from_address (str): the address creating the contract.  This must be unlocked.
        bytecode_file (_type_): _description_

    Returns:
        _type_: _description_
    """

    bytecode = None
    with open(bytecode_file, 'r') as f:
        bytecode =  f.read()

    contract = {
        "from": from_address,
        "gas": "0x76c0",
        "data": f"0x{str(bytecode)}"
    }

    print(f"Sending the contract params: {contract}")

    response = send_request(
        session=session,
        endpoint=_endpoint,
        method="eth_sendTransaction",
        params=[contract]        
    )

    return response


if __name__ == "__main__":

    print(f"The RPC Endpoint is : {_endpoint}")
    
    session = requests.session()

    account_list = get_accounts(session)
    print(f"The accounts are {account_list}")

    funded_account = None
    for account in account_list:
        balance = get_account_balance(session, account)
        print(f"Account {account} has balance {balance} wei")
        if balance > 500:
            funded_account = account

    #print(get_peers(session))

    project_root = "C:\\Users\\john_\\git\\eth-explore"

    unlock_account(session, funded_account, f"{project_root}\\private-network\\cfg\\notsecret.txt", 30)

    contract_result = create_contract(session, from_address=funded_account, bytecode_file=f"{project_root}\\bin\\src\\contracts\\ComplementStorage.bin")
    print(contract_result.json())

