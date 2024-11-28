// Copyright 2024 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
#ifndef PACKAGES_CAMERA_CAMERA_WINDOWS_WINDOWS_TASK_RUNNER_WINDOW_H_
#define PACKAGES_CAMERA_CAMERA_WINDOWS_WINDOWS_TASK_RUNNER_WINDOW_H_

#include <windows.h>

#include <chrono>
#include <memory>
#include <mutex>
#include <queue>
#include <string>

#include "task_runner.h"

namespace camera_windows {

// Hidden HWND responsible for processing camera tasks on main thread
// Adapted from Flutter Engine, see:
//   https://github.com/flutter/flutter/issues/134346#issuecomment-2141023146
// and:
//   https://github.com/flutter/engine/blob/d7c0bcfe7a30408b0722c9d47d8b0b1e4cdb9c81/shell/platform/windows/task_runner_window.h
class TaskRunnerWindow : public TaskRunner {
 public:
  virtual void EnqueueTask(TaskClosure task);

  TaskRunnerWindow();
  ~TaskRunnerWindow();

 private:
  void ProcessTasks();

  WNDCLASS RegisterWindowClass();

  LRESULT
  HandleMessage(UINT const message, WPARAM const wparam,
                LPARAM const lparam) noexcept;

  static LRESULT CALLBACK WndProc(HWND const window, UINT const message,
                                  WPARAM const wparam,
                                  LPARAM const lparam) noexcept;

  HWND window_handle_;
  std::wstring window_class_name_;
  std::mutex tasks_mutex_;
  std::queue<TaskClosure> tasks_;

  // Prevent copying.
  TaskRunnerWindow(TaskRunnerWindow const&) = delete;
  TaskRunnerWindow& operator=(TaskRunnerWindow const&) = delete;
};
}  // namespace camera_windows

#endif  // PACKAGES_CAMERA_CAMERA_WINDOWS_WINDOWS_TASK_RUNNER_WINDOW_H_