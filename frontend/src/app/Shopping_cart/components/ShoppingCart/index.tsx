import { useContext, useEffect, useState } from 'react';
import { UserContext } from '../../../../Provider';
import APIService from '../../../../shared/components/APIService/index';
import { PopUp } from '../PopUp/index';
import './styles.css';

const api = new APIService();

export const addToCart = async (user: any, item: any, context: any) => {
  const {message} = (await api.addItemToCart(user.id, item.id)).data;
  if (message === 'Item added to cart') {
    const items = (await api.getAllItems()).data;
    const itemToAdd = items.find((i) => i.id === item.id)
    context.setCartContext([...context.cart, {id: item.id, name: itemToAdd.name, price: itemToAdd.price, quantity: 1}]);
    console.log('Item added to cart');
  } else {
    console.error('Error adding item to cart');
  }
};

const removeFromCart = async (user: any, item: any, context: any) => {
  const {message} = (await api.removeItemFromCart(user.id, item.id)).data;
  if (message === 'Item removed from cart') {
    context.setCartContext(context.cart.filter((cartItem: any) => cartItem.id !== item.id));
    console.log('Item removed from cart');
  } else {
    console.error('Error removing item from cart');
  }
};

const increaseQuantity = async (user: any, item: any, context: any) => {
  const item_quantity = context.cart.find((cartItem: any) => cartItem.id === item.id).quantity;
  const {message} = (await api.updateItemFromCart(user.id, item.id, item_quantity + 1)).data;
  if(message === 'Item updated')
    context.setCartContext(context.cart.map(
      (cartItem: any) => cartItem.id === item.id ? {...cartItem, quantity: item_quantity + 1} : cartItem)
    );
};

const decreaseQuantity = async (user: any, item: any, context: any) => {
  const item_quantity = context.cart.find((cartItem: any) => cartItem.id === item.id).quantity;
  const {message} = (await api.updateItemFromCart(user.id, item.id, item_quantity - 1)).data;
  if(message === 'Item updated') {
    context.setCartContext(context.cart.map(
      (cartItem: any) => cartItem.id === item.id ? {...cartItem, quantity: item_quantity - 1} : cartItem)
    );
    console.log('Item updated');
  }
  else {
    console.error('Error updating item quantity');
  }
};

const finishOrder = async (user: any, context: any) => {
  const totalPrice = context.cart.reduce((acc: number, item: any) => acc + item.price * item.quantity, 0.0);
  const {message} = (await api.finishOrder(user.id, totalPrice)).data;
  if(message === 'Order finished') {
    context.setCartContext([]);
    console.log('Order finished');
  } else {
    console.error('Error finishing order');
  }
};

export const ShoppingCart = () => {
  const {user, cart, setCartContext} = useContext(UserContext);
  const [showPopUpDeleteItem, setShowPopUpDeleteItem] = useState(false);
  const [showPopUpFinishOrder, setShowPopUpFinishOrder] = useState(false);

  useEffect(() => {
    const getCart = async () => {
      if(user !== null && cart.length === 0) {
        setCartContext(await api.getShoppingCart(user.id));
      }
    };
    getCart().then(() => {});
  }, []);

  return (
    <div className="container" style={{background: '#dee0dc'}}>
      <h1 className="shopping_cart_title">Shopping Cart</h1>
      <ul>
        {cart.map((item: any) => (
          <div>
            <li key={item.id} className="list_item_shopping_cart" style={{background: '#f5f5f0'}}>
              <div className="container_buttons">
                <button className="button_remove" style={{background: '#9a9c98'}}
                        onClick={() => setShowPopUpDeleteItem(true)}>
                  <img src="../src/app/Shopping_cart/assets/icons/trash.png"
                      alt='Remove from Cart' className='image_button_remove'/>
                </button>
                <div className="container_plus_and_minus">
                  <button className="button" style={{background: '#54B544'}}
                          onClick={() => increaseQuantity(user, item, {cart, setCartContext})}> + </button>
                  <button className="button" style={{background: '#FD3939'}}
                          onClick={() => decreaseQuantity(user, item, {cart, setCartContext})}> - </button>
                </div>
              </div>
              <div>
                <h2>{item.name} x {item.quantity}</h2>
                <p>{(item.price * item.quantity).toFixed(2)} $</p>
              </div>
            </li>
            {showPopUpDeleteItem && (
              <PopUp
                title="Remove from Cart?"
                text="Do you want to remove this item from your cart?"
                onReject={() => { setShowPopUpDeleteItem(false); }}
                onAccept={() => { removeFromCart(user, item, {cart, setCartContext}); setShowPopUpDeleteItem(false); }}
                />)
            }
          </div>
        ))}
      {cart.length === 0 ?
        <h3>Your cart is empty</h3> :
        <button className="button_finish_order"
                onClick={() => setShowPopUpFinishOrder(true)}>Finish the Order</button>
      }
      </ul>
      {showPopUpFinishOrder && (
        <PopUp
          title="Finish the Order?"
          text="Do you want to finish the order?"
          onReject={() => { setShowPopUpFinishOrder(false); }}
          onAccept={() => { finishOrder(user, {cart, setCartContext}); setShowPopUpFinishOrder(false); }}
          />)
      }
    </div>
  );
};
