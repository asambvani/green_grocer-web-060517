def consolidate_cart(cart)
  new_hash = {}
  cart.each do |element|
    element.each do |key1, value1|
      if new_hash.keys.include?(key1)
        new_hash[key1][:count] = new_hash[key1][:count] + 1
        puts "Key: #{key1} COUNT: #{new_hash[key1][:count]}"
      else
        new_hash[key1] = {
          :price => value1[:price],
          :clearance => value1[:clearance],
          :count => 1
        }
      end
    end
  end
  return new_hash
end

def apply_coupons(cart, coupons)
  coupon_array = []
  return_hash = {}
  coupons.each do |element|
    coupon_array << element[:item]
  end
  cart.each do |key1, value1|
    if coupon_array.include?(key1)
      coupons.each do |coupon_element|
        if coupon_element[:item] == key1
          coupon_number = coupon_element[:num]
          coupon_cost = coupon_element[:cost]
          new_name = "#{key1} W/COUPON"
          if cart[key1][:count] > coupon_number
            remainder = cart[key1][:count] % coupon_number
            return_hash[new_name] = {
              :price => coupon_cost,
              :clearance => cart[key1][:clearance],
              :count => cart[key1][:count] / coupon_number
            }
            return_hash[key1] = {
              :price => cart[key1][:price],
              :clearance => cart[key1][:clearance],
              :count => remainder
            }
          elsif cart[key1][:count] == coupon_number
            return_hash[new_name] = {
              :price => coupon_cost,
              :clearance => cart[key1][:clearance],
              :count => 1
            }
            return_hash[key1] = cart[key1]
            return_hash[key1][:count] = 0
          else
            return_hash[new_name] = cart[key1]
            return_hash[new_name][:price] = coupon_cost
            return_hash[new_name][:count] = 1
          end
        end
      end
    else
      return_hash[key1] = cart[key1]
    end
  end
  return return_hash
end

def apply_clearance(cart)
  return_hash = {}
  cart.each do |key1, value1|
    return_hash[key1] = {}
    if value1[:clearance] == true
      return_hash[key1] = value1
      return_hash[key1][:price] = (value1[:price] * 0.8).round(1)
    else return_hash[key1] = value1
    end
  end
  return return_hash
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  consolidated_cart = apply_coupons(consolidated_cart, coupons)
  consolidated_cart = apply_clearance(consolidated_cart)
  total = 0
  consolidated_cart.each do |key1, value1|
    total += value1[:price] * value1[:count]
  end
  if total > 100
    return total * 0.9
  else
    return total
  end
end
