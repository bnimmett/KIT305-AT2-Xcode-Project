//
//  classes.swift
//  KIT305 AT2
//
//  Created by Brandon Nimmett on 9/5/20.
//  Copyright © 2020 Lindsay Wells. All rights reserved.
//

public struct Raffle
{
    var raffle_id:Int32 = -1
    var raffle_name:String
    var raffle_description:String
    var draw_date:String
    var start_date:String
    var price:Double
    var prize:Int32
    var max:Int32
    var current:Int32 
    var margin:Bool
    var archived:Bool
}

public struct Customer
{
    var customer_id:Int32// = -1
    var customer_name:String
    var email:String
    var phone:Int32
    var postcode:Int32
    var archived:Bool
}

public struct Ticket
{
    var ticket_id:Int32 = -1
    var raffle_id:Int32
    var customer_id:Int32
    var number:Int32
    var sold:String = ""
    var win:Int32
}
