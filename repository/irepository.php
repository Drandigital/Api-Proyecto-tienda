<?php

interface Irepository{

    public function connectar();
    public function disconnect();
    
    public function create($model,$obj);
    public function update($model,$obj);

    public function delete($model,$id);
    public function findAll($model);
    public function findOne($model,$id);

    public function findAllOption($model,$object_keys_values,$operators);
    public function updateOption($model,$obj,$object_keys_values,$operators);
    public function deleteOption($model,$object_keys_values,$operators);

} 


